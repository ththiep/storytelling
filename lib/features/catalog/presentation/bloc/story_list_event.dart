import 'package:equatable/equatable.dart';

sealed class StoryListEvent extends Equatable {
  const StoryListEvent();

  @override
  List<Object?> get props => [];
}

final class StoryListStarted extends StoryListEvent {
  const StoryListStarted();
}

final class StoryListRefreshed extends StoryListEvent {
  const StoryListRefreshed();
}
