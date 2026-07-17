import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storytelling/core/recording/story_voice_recording_service.dart';
import 'package:storytelling/shared/models/story.dart';
import 'story_talk_event.dart';
import 'story_talk_state.dart';

class StoryTalkBloc extends Bloc<StoryTalkEvent, StoryTalkState> {
  StoryTalkBloc({required this.recordingService}) : super(_emptyState) {
    on<StoryTalkStarted>(_onStarted);
    on<StoryTalkPracticeToggled>(_onPracticeToggled);
    on<StoryTalkRecordingPlaybackPressed>(_onRecordingPlaybackPressed);
    on<StoryTalkPageChanged>(_onPageChanged);
  }

  final StoryVoiceRecordingService recordingService;

  static const _emptyState = StoryTalkState(
    story: _emptyStory,
    pages: [],
    pageIndex: 0,
    status: TalkStatus.busy,
    hasRecording: false,
    practicedPageIndexes: <int>{},
  );

  Future<void> _onStarted(
    StoryTalkStarted event,
    Emitter<StoryTalkState> emit,
  ) async {
    final initial = StoryTalkState.initial(event.story);
    emit(initial);
    await _loadRecordingForPage(emit, initial);
  }

  Future<void> _onPracticeToggled(
    StoryTalkPracticeToggled event,
    Emitter<StoryTalkState> emit,
  ) async {
    final page = state.currentPage;
    if (page == null || state.isBusy) return;

    final wasRecording = state.isRecording;
    emit(state.copyWith(status: TalkStatus.busy, clearNotice: true));
    try {
      if (wasRecording) {
        final file = await recordingService.stopPageRecording(
          storyId: state.story.id,
          pageNumber: page.pageNumber,
        );
        final practiced = {...state.practicedPageIndexes};
        if (file != null) practiced.add(state.pageIndex);
        emit(
          state.copyWith(
            status: TalkStatus.ready,
            hasRecording: file != null,
            practicedPageIndexes: practiced,
            clearNotice: true,
          ),
        );
      } else {
        await recordingService.startPageRecording(
          storyId: state.story.id,
          pageNumber: page.pageNumber,
        );
        emit(
          state.copyWith(
            status: TalkStatus.recording,
            hasRecording: false,
            clearNotice: true,
          ),
        );
      }
    } catch (_) {
      emit(
        state.copyWith(
          status: TalkStatus.ready,
          notice: TalkNotice.recordingFailed,
        ),
      );
    }
  }

  Future<void> _onRecordingPlaybackPressed(
    StoryTalkRecordingPlaybackPressed event,
    Emitter<StoryTalkState> emit,
  ) async {
    final page = state.currentPage;
    if (page == null || state.isBusy || state.isRecording) return;
    if (!state.hasRecording) return;

    emit(state.copyWith(status: TalkStatus.busy, clearNotice: true));
    try {
      await recordingService.playPageRecording(
        storyId: state.story.id,
        pageNumber: page.pageNumber,
      );
      emit(state.copyWith(status: TalkStatus.ready, clearNotice: true));
    } catch (_) {
      emit(
        state.copyWith(
          status: TalkStatus.ready,
          notice: TalkNotice.playbackFailed,
        ),
      );
    }
  }

  Future<void> _onPageChanged(
    StoryTalkPageChanged event,
    Emitter<StoryTalkState> emit,
  ) async {
    if (event.pageIndex < 0 || event.pageIndex >= state.pages.length) return;
    if (event.pageIndex == state.pageIndex) return;

    await recordingService.cancelRecording();
    await recordingService.stopPlayback();
    final next = state.copyWith(
      pageIndex: event.pageIndex,
      status: TalkStatus.busy,
      hasRecording: false,
      clearNotice: true,
    );
    emit(next);
    await _loadRecordingForPage(emit, next);
  }

  Future<void> _loadRecordingForPage(
    Emitter<StoryTalkState> emit,
    StoryTalkState current,
  ) async {
    final page = current.currentPage;
    if (page == null) {
      emit(current.copyWith(status: TalkStatus.ready, clearNotice: true));
      return;
    }

    try {
      final file = await recordingService.latestRecording(
        storyId: current.story.id,
        pageNumber: page.pageNumber,
      );
      final practiced = {...current.practicedPageIndexes};
      if (file != null) practiced.add(current.pageIndex);
      emit(
        current.copyWith(
          status: TalkStatus.ready,
          hasRecording: file != null,
          practicedPageIndexes: practiced,
          clearNotice: true,
        ),
      );
    } catch (_) {
      emit(current.copyWith(status: TalkStatus.ready, clearNotice: true));
    }
  }

  @override
  Future<void> close() async {
    await recordingService.dispose();
    return super.close();
  }
}

const _emptyStory = StoryDetail(
  id: -1,
  title: '',
  author: '',
  overview: '',
  level: 0,
  durationMinutes: 0,
  imageUrl: '',
  license: '',
  voices: [],
  addedToChildren: [],
  status: '',
  isFavorite: false,
  progressSeconds: 0,
);
