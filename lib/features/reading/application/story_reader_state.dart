import 'package:equatable/equatable.dart';

import 'package:storytelling/shared/models/story.dart';
import 'package:storytelling/core/utils/word_timing_utils.dart';

enum ReaderStatus { idle, speaking, paused, finished }

sealed class StoryReaderState extends Equatable {
  const StoryReaderState();

  @override
  List<Object?> get props => [];
}

final class StoryReaderInitial extends StoryReaderState {
  const StoryReaderInitial();
}

final class StoryReaderLoading extends StoryReaderState {
  const StoryReaderLoading();
}

final class StoryReaderFailure extends StoryReaderState {
  const StoryReaderFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class StoryReaderReady extends StoryReaderState {
  const StoryReaderReady({
    required this.story,
    required this.playback,
    required this.pageIndex,
    required this.activeWordIndex,
    required this.status,
    required this.autoTurnPage,
  });

  final StoryDetail story;
  final StoryPlayback playback;
  final int pageIndex;
  final int activeWordIndex;
  final ReaderStatus status;
  final bool autoTurnPage;

  StoryPage? get currentPage =>
      playback.pages.isEmpty ? null : playback.pages[pageIndex];

  bool get isSpeaking => status == ReaderStatus.speaking;
  bool get isPaused => status == ReaderStatus.paused;
  bool get isFinished => status == ReaderStatus.finished;

  StoryReaderReady copyWith({
    StoryDetail? story,
    StoryPlayback? playback,
    int? pageIndex,
    int? activeWordIndex,
    ReaderStatus? status,
    bool? autoTurnPage,
  }) {
    return StoryReaderReady(
      story: story ?? this.story,
      playback: playback ?? this.playback,
      pageIndex: pageIndex ?? this.pageIndex,
      activeWordIndex: activeWordIndex ?? this.activeWordIndex,
      status: status ?? this.status,
      autoTurnPage: autoTurnPage ?? this.autoTurnPage,
    );
  }

  @override
  List<Object?> get props => [
    story.id,
    playback.audioSource,
    pageIndex,
    activeWordIndex,
    status,
    autoTurnPage,
  ];
}

final class StoryReaderCompleted extends StoryReaderState {
  const StoryReaderCompleted({
    required this.story,
    required this.playback,
  });

  final StoryDetail story;
  final StoryPlayback playback;

  @override
  List<Object?> get props => [story.id, playback.audioSource];
}
