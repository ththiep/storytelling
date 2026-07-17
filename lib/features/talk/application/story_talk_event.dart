import 'package:equatable/equatable.dart';

import 'package:storytelling/shared/models/story.dart';

sealed class StoryTalkEvent extends Equatable {
  const StoryTalkEvent();

  @override
  List<Object?> get props => [];
}

final class StoryTalkStarted extends StoryTalkEvent {
  const StoryTalkStarted(this.story);

  final StoryDetail story;

  @override
  List<Object?> get props => [story.id];
}

final class StoryTalkPracticeToggled extends StoryTalkEvent {
  const StoryTalkPracticeToggled();
}

final class StoryTalkRecordingPlaybackPressed extends StoryTalkEvent {
  const StoryTalkRecordingPlaybackPressed();
}

final class StoryTalkPageChanged extends StoryTalkEvent {
  const StoryTalkPageChanged(this.pageIndex);

  final int pageIndex;

  @override
  List<Object?> get props => [pageIndex];
}
