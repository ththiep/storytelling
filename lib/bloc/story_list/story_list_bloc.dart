import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/story_repository.dart';
import 'story_list_event.dart';
import 'story_list_state.dart';

class StoryListBloc extends Bloc<StoryListEvent, StoryListState> {
  StoryListBloc({required this._repository})
      : super(const StoryListInitial()) {
    on<StoryListStarted>(_onStarted);
    on<StoryListRefreshed>(_onRefreshed);
  }

  final StoryRepository _repository;

  Future<void> _onStarted(
    StoryListStarted event,
    Emitter<StoryListState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onRefreshed(
    StoryListRefreshed event,
    Emitter<StoryListState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<StoryListState> emit) async {
    emit(const StoryListLoading());
    try {
      final stories = await _repository.fetchStories();
      emit(StoryListLoaded(stories));
    } catch (error) {
      emit(StoryListFailure(error.toString()));
    }
  }
}
