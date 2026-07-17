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
      final dtos = await _api.fetchStories();
      return dtos.map((dto) => dto.toDomain()).toList(growable: false);
    } catch (error) {
      throw parseApiException(error);
    }
  }

  @override
  Future<StoryDetail> fetchStoryById(int id) async {
    try {
      final dto = await _api.fetchStoryById(id);
      return dto.toDomain();
    } catch (error) {
      throw parseApiException(error);
    }
  }
}
