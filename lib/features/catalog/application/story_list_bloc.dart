import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storytelling/core/logging/app_logger.dart';
import 'package:storytelling/features/catalog/data/story_repository.dart';

import 'story_list_event.dart';
import 'story_list_state.dart';

class StoryListBloc extends Bloc<StoryListEvent, StoryListState> {
  StoryListBloc({required this._repository}) : super(const StoryListInitial()) {
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
    AppLogger.info('catalog', 'Loading story list');
    emit(const StoryListLoading());
    try {
      final stories = await _repository.fetchStories();
      AppLogger.info('catalog', 'Loaded story list count=${stories.length}');
      emit(StoryListLoaded(stories));
    } catch (error, stackTrace) {
      AppLogger.error(
        'catalog',
        'Failed to load story list',
        error: error,
        stackTrace: stackTrace,
      );
      emit(StoryListFailure(error.toString()));
    }
  }
}
