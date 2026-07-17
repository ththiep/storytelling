import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../core/audio/audio_engine.dart';
import '../../core/config/api_config.dart';
import '../../core/network/dio_client.dart';
import '../../core/permissions/app_permission_service.dart';
import '../../core/recording/story_voice_recording_service.dart';
import '../../features/catalog/data/api_story_repository.dart';
import '../../features/catalog/data/remote/story_api_service.dart';
import '../../features/catalog/data/story_repository.dart';
import '../../features/catalog/application/story_list_bloc.dart';
import '../../features/reading/application/story_reader_bloc.dart';
import '../../features/talk/application/story_talk_bloc.dart';

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

  final repository =
      storyRepository ??
      (useRemoteApi
          ? ApiStoryRepository(getIt<StoryApiService>())
          : MockStoryRepository());

  getIt
    ..registerSingleton<ApiConfig>(config)
    ..registerLazySingleton<Dio>(() => createDioClient(getIt<ApiConfig>()))
    ..registerLazySingleton<StoryApiService>(
      () => StoryApiService(getIt<Dio>()),
    )
    ..registerLazySingleton<AppPermissionService>(AppPermissionService.new)
    ..registerFactory<StoryVoiceRecordingService>(
      StoryVoiceRecordingService.new,
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
    )
    ..registerFactory<StoryTalkBloc>(
      () =>
          StoryTalkBloc(recordingService: getIt<StoryVoiceRecordingService>()),
    );
}

Future<void> resetDependencies() => getIt.reset();
