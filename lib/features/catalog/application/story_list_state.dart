import 'package:equatable/equatable.dart';

import 'package:storytelling/shared/models/story.dart';

sealed class StoryListState extends Equatable {
  const StoryListState();

  @override
  List<Object?> get props => [];
}

final class StoryListInitial extends StoryListState {
  const StoryListInitial();
}

final class StoryListLoading extends StoryListState {
  const StoryListLoading();
}

final class StoryListLoaded extends StoryListState {
  const StoryListLoaded(this.stories);

  final List<StoryDetail> stories;

  @override
  List<Object?> get props => [stories];
}

final class StoryListFailure extends StoryListState {
  const StoryListFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
