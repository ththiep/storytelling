import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/story_repository.dart';
import '../../services/audio_engine.dart';
import '../../services/narration_engine.dart';
import '../../utils/word_timing_utils.dart';
import 'story_reader_event.dart';
import 'story_reader_state.dart';

class StoryReaderBloc extends Bloc<StoryReaderEvent, StoryReaderState> {
  StoryReaderBloc({required this._repository, required AudioEngine audioEngine})
    : _audio = audioEngine,
      super(const StoryReaderInitial()) {
    on<StoryReaderStarted>(_onStarted);
    on<StoryReaderPlayPressed>(_onPlay);
    on<StoryReaderPausePressed>(_onPause);
    on<StoryReaderReplayPressed>(_onReplay);
    on<StoryReaderClosed>(_onClosed);
    on<StoryReaderPageChanged>(_onPageChanged);
    on<StoryReaderAutoTurnPageToggled>(_onAutoTurnPageToggled);
    on<StoryReaderTimelineProgressed>(_onTimelineProgressed);
    on<StoryReaderSpeakCompleted>(_onSpeakCompleted);
    on<StoryReaderListenAgainPressed>(_onListenAgain);

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
          autoTurnPage: true,
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
      try {
        await _audio.resume();
      } catch (error) {
        emit(StoryReaderFailure(error.toString()));
      }
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

  Future<void> _onPageChanged(
    StoryReaderPageChanged event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderReady) return;
    if (event.pageIndex < 0 ||
        event.pageIndex >= current.playback.pages.length) {
      return;
    }
    if (current.pageIndex == event.pageIndex) return;

    emit(current.copyWith(pageIndex: event.pageIndex, activeWordIndex: -1));
    await _audio.seekTo(current.playback.pages[event.pageIndex].startTimeMs);
  }

  void _onAutoTurnPageToggled(
    StoryReaderAutoTurnPageToggled event,
    Emitter<StoryReaderState> emit,
  ) {
    final current = state;
    if (current is! StoryReaderReady) return;
    if (current.autoTurnPage == event.enabled) return;

    emit(current.copyWith(autoTurnPage: event.enabled));
  }

  void _onTimelineProgressed(
    StoryReaderTimelineProgressed event,
    Emitter<StoryReaderState> emit,
  ) {
    final current = state;
    if (current is! StoryReaderReady) return;
    if (!current.isSpeaking) return;

    final nextPageIndex = current.autoTurnPage
        ? event.pageIndex
        : current.pageIndex;
    final nextWordIndex = event.pageIndex == nextPageIndex
        ? event.wordIndex
        : -1;

    if (current.pageIndex == nextPageIndex &&
        current.activeWordIndex == nextWordIndex) {
      return;
    }
    emit(
      current.copyWith(
        pageIndex: nextPageIndex,
        activeWordIndex: nextWordIndex,
      ),
    );
  }

  void _onSpeakCompleted(
    StoryReaderSpeakCompleted event,
    Emitter<StoryReaderState> emit,
  ) {
    final current = state;
    if (current is! StoryReaderReady) return;
    if (!current.isSpeaking) return;

    emit(
      StoryReaderCompleted(
        story: current.story,
        playback: current.playback,
      ),
    );
  }

  Future<void> _onListenAgain(
    StoryReaderListenAgainPressed event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderCompleted) return;

    final ready = StoryReaderReady(
      story: current.story,
      playback: current.playback,
      pageIndex: 0,
      activeWordIndex: -1,
      status: ReaderStatus.speaking,
      autoTurnPage: true,
    );
    emit(ready);
    await _startPlayback(emit, ready);
  }

  Future<void> _startPlayback(
    Emitter<StoryReaderState> emit,
    StoryReaderReady current,
  ) async {
    try {
      emit(
        current.copyWith(
          status: ReaderStatus.speaking,
          pageIndex: 0,
          activeWordIndex: -1,
        ),
      );
      await _audio.play(current.playback);
    } catch (error) {
      emit(StoryReaderFailure(error.toString()));
    }
  }

  @override
  Future<void> close() async {
    await _audioSub?.cancel();
    await _audio.dispose();
    return super.close();
  }
}
