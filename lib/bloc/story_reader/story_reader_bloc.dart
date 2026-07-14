import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/story_repository.dart';
import '../../services/audio_engine.dart';
import '../../services/narration_engine.dart';
import '../../utils/word_timing_utils.dart';
import 'story_reader_event.dart';
import 'story_reader_state.dart';

class StoryReaderBloc extends Bloc<StoryReaderEvent, StoryReaderState> {
  StoryReaderBloc({
    required this._repository,
    required AudioEngine audioEngine,
  })  : _audio = audioEngine,
        super(const StoryReaderInitial()) {
    on<StoryReaderStarted>(_onStarted);
    on<StoryReaderPlayPressed>(_onPlay);
    on<StoryReaderPausePressed>(_onPause);
    on<StoryReaderReplayPressed>(_onReplay);
    on<StoryReaderClosed>(_onClosed);
    on<StoryReaderTimelineProgressed>(_onTimelineProgressed);
    on<StoryReaderSpeakCompleted>(_onSpeakCompleted);

    _audioSub = _audio.events.listen(_onAudioEvent);
  }

  final StoryRepository _repository;
  final AudioEngine _audio;
  StreamSubscription<NarrationEvent>? _audioSub;

  void _onAudioEvent(NarrationEvent event) {
    switch (event) {
      case NarrationStarted():
        break;
      case NarrationTimelineProgress(:final pageIndex, :final wordIndex):
        add(
          StoryReaderTimelineProgressed(
            pageIndex: pageIndex,
            wordIndex: wordIndex,
          ),
        );
      case NarrationCompleted():
        add(const StoryReaderSpeakCompleted());
      case NarrationPaused():
        break;
    }
  }

  Future<void> _onStarted(
    StoryReaderStarted event,
    Emitter<StoryReaderState> emit,
  ) async {
    emit(const StoryReaderLoading());
    try {
      await _audio.prepare();
      final story = await _repository.fetchStoryById(event.storyId);
      final playback = StoryPlayback.fromDetail(story);
      emit(
        StoryReaderReady(
          story: story,
          playback: playback,
          pageIndex: 0,
          activeWordIndex: -1,
          status: ReaderStatus.idle,
        ),
      );
      add(const StoryReaderPlayPressed());
    } catch (error) {
      emit(StoryReaderFailure(error.toString()));
    }
  }

  Future<void> _onPlay(
    StoryReaderPlayPressed event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderReady) return;
    if (current.isPaused) {
      emit(current.copyWith(status: ReaderStatus.speaking));
      await _audio.resume();
      return;
    }
    await _startPlayback(emit, current);
  }

  Future<void> _onPause(
    StoryReaderPausePressed event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderReady || !current.isSpeaking) return;
    await _audio.pause();
    emit(current.copyWith(status: ReaderStatus.paused));
  }

  Future<void> _onReplay(
    StoryReaderReplayPressed event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderReady) return;
    await _startPlayback(emit, current);
  }

  Future<void> _onClosed(
    StoryReaderClosed event,
    Emitter<StoryReaderState> emit,
  ) async {
    await _audio.stop();
  }

  void _onTimelineProgressed(
    StoryReaderTimelineProgressed event,
    Emitter<StoryReaderState> emit,
  ) {
    final current = state;
    if (current is! StoryReaderReady) return;
    if (!current.isSpeaking) return;
    if (current.pageIndex == event.pageIndex &&
        current.activeWordIndex == event.wordIndex) {
      return;
    }
    emit(
      current.copyWith(
        pageIndex: event.pageIndex,
        activeWordIndex: event.wordIndex,
      ),
    );
  }

  Future<void> _onSpeakCompleted(
    StoryReaderSpeakCompleted event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderReady) return;
    if (!current.isSpeaking) return;

    final lastPageIndex =
        current.playback.pages.isEmpty ? 0 : current.playback.pages.length - 1;
    final lastPage = current.playback.pages.isEmpty
        ? null
        : current.playback.pages[lastPageIndex];
    final lastWordIndex =
        lastPage == null || lastPage.allWords.isEmpty
            ? -1
            : lastPage.allWords.length - 1;

    emit(
      current.copyWith(
        pageIndex: lastPageIndex,
        activeWordIndex: lastWordIndex,
        status: ReaderStatus.finished,
      ),
    );
  }

  Future<void> _startPlayback(
    Emitter<StoryReaderState> emit,
    StoryReaderReady current,
  ) async {
    emit(
      current.copyWith(
        status: ReaderStatus.speaking,
        pageIndex: 0,
        activeWordIndex: -1,
      ),
    );
    await _audio.play(current.playback);
  }

  @override
  Future<void> close() async {
    await _audioSub?.cancel();
    await _audio.dispose();
    return super.close();
  }
}
