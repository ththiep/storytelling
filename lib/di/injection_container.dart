import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../bloc/story_list/story_list_bloc.dart';
import '../bloc/story_reader/story_reader_bloc.dart';
import '../core/config/api_config.dart';
import '../core/network/dio_client.dart';
import '../data/api_story_repository.dart';
import '../data/remote/story_api_service.dart';
import '../data/story_repository.dart';
import '../services/audio_engine.dart';

final GetIt getIt = GetIt.instance;

/// Registers app-wide dependencies.
///
/// Set [useRemoteApi] to `true` to load stories from the REST backend.
/// Pass [storyRepository] in tests to override the default repository.
Future<void> configureDependencies({
  StoryRepository? storyRepository,
  bool useRemoteApi = false,
  ApiConfig? apiConfig,
}) async {
  final config = apiConfig ?? ApiConfig.instance;

  final repository = storyRepository ??
      (useRemoteApi
          ? ApiStoryRepository(getIt<StoryApiService>())
          : MockStoryRepository());

  getIt
    ..registerSingleton<ApiConfig>(config)
    ..registerLazySingleton<Dio>(() => createDioClient(getIt<ApiConfig>()))
    ..registerLazySingleton<StoryApiService>(
      () => StoryApiService(getIt<Dio>()),
    )
    ..registerLazySingleton<StoryRepository>(() => repository)
    ..registerFactory<AudioEngine>(AudioEngine.new)
    ..registerFactory<StoryListBloc>(
      () => StoryListBloc(repository: getIt<StoryRepository>()),
    )
    ..registerFactory<StoryReaderBloc>(
      () => StoryReaderBloc(
        repository: getIt<StoryRepository>(),
        audioEngine: getIt<AudioEngine>(),
      ),
    );
}

Future<void> resetDependencies() => getIt.reset();
