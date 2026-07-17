import 'package:equatable/equatable.dart';

sealed class StoryReaderEvent extends Equatable {
  const StoryReaderEvent();

  @override
  List<Object?> get props => [];
}

final class StoryReaderStarted extends StoryReaderEvent {
  const StoryReaderStarted(this.storyId);

  final int storyId;

  @override
  List<Object?> get props => [storyId];
}

final class StoryReaderPlayPressed extends StoryReaderEvent {
  const StoryReaderPlayPressed();
}

final class StoryReaderPausePressed extends StoryReaderEvent {
  const StoryReaderPausePressed();
}

final class StoryReaderReplayPressed extends StoryReaderEvent {
  const StoryReaderReplayPressed();
}

final class StoryReaderClosed extends StoryReaderEvent {
  const StoryReaderClosed();
}

final class StoryReaderPageChanged extends StoryReaderEvent {
  const StoryReaderPageChanged(this.pageIndex);

  final int pageIndex;

  @override
  List<Object?> get props => [pageIndex];
}

final class StoryReaderAutoTurnPageToggled extends StoryReaderEvent {
  const StoryReaderAutoTurnPageToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}

final class StoryReaderTimelineProgressed extends StoryReaderEvent {
  const StoryReaderTimelineProgressed({
    required this.pageIndex,
    required this.wordIndex,
  });

  final int pageIndex;
  final int wordIndex;

  @override
  List<Object?> get props => [pageIndex, wordIndex];
}

final class StoryReaderSpeakCompleted extends StoryReaderEvent {
  const StoryReaderSpeakCompleted();
}

final class StoryReaderListenAgainPressed extends StoryReaderEvent {
  const StoryReaderListenAgainPressed();
}
