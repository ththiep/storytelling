import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storytelling/core/audio/audio_engine.dart';
import 'package:storytelling/core/audio/narration_events.dart';
import 'package:storytelling/core/logging/app_logger.dart';
import 'package:storytelling/core/utils/word_timing_utils.dart';
import 'package:storytelling/features/catalog/data/story_repository.dart';
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
    on<StoryReaderSkipToCompletedPressed>(_onSkipToCompleted);

    _audioSub = _audio.events.listen(_onAudioEvent);
  }

  final StoryRepository _repository;
  final AudioEngine _audio;
  StreamSubscription<NarrationEvent>? _audioSub;

  void _onAudioEvent(NarrationEvent event) {
    switch (event) {
      case NarrationStarted():
        AppLogger.info('reader', 'Narration started');
        break;
      case NarrationTimelineProgress(:final pageIndex, :final wordIndex):
        add(
          StoryReaderTimelineProgressed(
            pageIndex: pageIndex,
            wordIndex: wordIndex,
          ),
        );
      case NarrationCompleted():
        AppLogger.info('reader', 'Narration completed event received');
        add(const StoryReaderSpeakCompleted());
      case NarrationPaused():
        AppLogger.info('reader', 'Narration paused event received');
        break;
    }
  }

  Future<void> _onStarted(
    StoryReaderStarted event,
    Emitter<StoryReaderState> emit,
  ) async {
    AppLogger.info('reader', 'Starting reader storyId=${event.storyId}');
    emit(const StoryReaderLoading());
    try {
      await _audio.prepare();
      final story = await _repository.fetchStoryById(event.storyId);
      final playback = StoryPlayback.fromDetail(story);
      AppLogger.info(
        'reader',
        'Reader ready storyId=${story.id} pages=${playback.pages.length} '
            'durationMs=${playback.durationMs}',
      );
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
    } catch (error, stackTrace) {
      AppLogger.error(
        'reader',
        'Failed to start reader storyId=${event.storyId}',
        error: error,
        stackTrace: stackTrace,
      );
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
      AppLogger.info('reader', 'Resume pressed pageIndex=${current.pageIndex}');
      emit(current.copyWith(status: ReaderStatus.speaking));
      try {
        await _audio.resume();
      } catch (error, stackTrace) {
        AppLogger.error(
          'reader',
          'Failed to resume playback',
          error: error,
          stackTrace: stackTrace,
        );
        emit(StoryReaderFailure(error.toString()));
      }
      return;
    }
    AppLogger.info('reader', 'Play pressed pageIndex=${current.pageIndex}');
    await _startPlayback(emit, current);
  }

  Future<void> _onPause(
    StoryReaderPausePressed event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderReady || !current.isSpeaking) return;
    AppLogger.info('reader', 'Pause pressed pageIndex=${current.pageIndex}');
    await _audio.pause();
    emit(current.copyWith(status: ReaderStatus.paused));
  }

  Future<void> _onReplay(
    StoryReaderReplayPressed event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderReady) return;
    AppLogger.info('reader', 'Replay pressed storyId=${current.story.id}');
    await _startPlayback(emit, current);
  }

  Future<void> _onClosed(
    StoryReaderClosed event,
    Emitter<StoryReaderState> emit,
  ) async {
    AppLogger.info('reader', 'Reader closed');
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

    AppLogger.info(
      'reader',
      'Manual page change ${current.pageIndex} -> ${event.pageIndex}',
    );
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

    AppLogger.info('reader', 'Auto page toggled enabled=${event.enabled}');
    emit(current.copyWith(autoTurnPage: event.enabled));
  }

  Future<void> _onTimelineProgressed(
    StoryReaderTimelineProgressed event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderReady) return;
    if (!current.isSpeaking) return;

    if (!current.autoTurnPage && event.pageIndex != current.pageIndex) {
      final page = current.currentPage;
      final endWordIndex = page == null
          ? current.activeWordIndex
          : wordIndexAt(page.allWords, page.endTimeMs);

      AppLogger.info(
        'reader',
        'Auto page off: pausing at pageIndex=${current.pageIndex} '
            'incomingPageIndex=${event.pageIndex}',
      );
      emit(
        current.copyWith(
          status: ReaderStatus.paused,
          activeWordIndex: endWordIndex,
        ),
      );
      await _audio.pause();
      if (page != null) {
        await _audio.seekTo(page.endTimeMs);
      }
      return;
    }

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
    if (current.pageIndex != nextPageIndex) {
      AppLogger.info(
        'reader',
        'Timeline page change ${current.pageIndex} -> $nextPageIndex',
      );
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

    AppLogger.info('reader', 'Story completed storyId=${current.story.id}');
    emit(
      StoryReaderCompleted(story: current.story, playback: current.playback),
    );
  }

  Future<void> _onSkipToCompleted(
    StoryReaderSkipToCompletedPressed event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderReady) return;

    AppLogger.info('reader', 'Skip to completed storyId=${current.story.id}');
    await _audio.stop();
    emit(
      StoryReaderCompleted(story: current.story, playback: current.playback),
    );
  }

  Future<void> _onListenAgain(
    StoryReaderListenAgainPressed event,
    Emitter<StoryReaderState> emit,
  ) async {
    final current = state;
    if (current is! StoryReaderCompleted) return;

    AppLogger.info('reader', 'Listen again storyId=${current.story.id}');
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
      AppLogger.info(
        'reader',
        'Starting playback storyId=${current.story.id} '
            'pages=${current.playback.pages.length}',
      );
      emit(
        current.copyWith(
          status: ReaderStatus.speaking,
          pageIndex: 0,
          activeWordIndex: -1,
        ),
      );
      await _audio.play(current.playback);
    } catch (error, stackTrace) {
      AppLogger.error(
        'reader',
        'Failed to start playback storyId=${current.story.id}',
        error: error,
        stackTrace: stackTrace,
      );
      emit(StoryReaderFailure(error.toString()));
    }
  }

  @override
  Future<void> close() async {
    AppLogger.debug('reader', 'Closing StoryReaderBloc');
    await _audioSub?.cancel();
    await _audio.dispose();
    return super.close();
  }
}
