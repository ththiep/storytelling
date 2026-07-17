import 'package:storytelling/core/logging/app_logger.dart';
import 'package:storytelling/core/network/dio_client.dart';
import 'package:storytelling/shared/models/story.dart';

import 'remote/story_api_service.dart';
import 'story_repository.dart';

/// Fetches stories from the REST API.
class ApiStoryRepository implements StoryRepository {
  ApiStoryRepository(this._api);

  final StoryApiService _api;

  @override
  Future<List<StoryDetail>> fetchStories() async {
    try {
      AppLogger.info('repository.api', 'Fetching stories from API');
      final dtos = await _api.fetchStories();
      final stories = dtos.map((dto) => dto.toDomain()).toList(growable: false);
      AppLogger.info(
        'repository.api',
        'Fetched API stories count=${stories.length}',
      );
      return stories;
    } catch (error, stackTrace) {
      AppLogger.error(
        'repository.api',
        'Failed to fetch API stories',
        error: error,
        stackTrace: stackTrace,
      );
      throw parseApiException(error);
    }
  }

  @override
  Future<StoryDetail> fetchStoryById(int id) async {
    try {
      AppLogger.info('repository.api', 'Fetching API story id=$id');
      final dto = await _api.fetchStoryById(id);
      final story = dto.toDomain();
      AppLogger.info(
        'repository.api',
        'Fetched API story id=${story.id} pages=${story.pages.length}',
      );
      return story;
    } catch (error, stackTrace) {
      AppLogger.error(
        'repository.api',
        'Failed to fetch API story id=$id',
        error: error,
        stackTrace: stackTrace,
      );
      throw parseApiException(error);
    }
  }
}
