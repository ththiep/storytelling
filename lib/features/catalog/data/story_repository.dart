import 'package:storytelling/core/logging/app_logger.dart';
import 'package:storytelling/shared/models/story.dart';

import 'mock/mock_story_data.dart';

abstract class StoryRepository {
  Future<List<StoryDetail>> fetchStories();
  Future<StoryDetail> fetchStoryById(int id);
}

/// Local mock data for development and tests.
class MockStoryRepository implements StoryRepository {
  MockStoryRepository({List<StoryDetail>? stories})
    : _stories = stories ?? mockStories();

  final List<StoryDetail> _stories;
  static const _latency = Duration(milliseconds: 450);

  @override
  Future<List<StoryDetail>> fetchStories() async {
    AppLogger.debug('repository.mock', 'Fetching mock stories');
    await Future<void>.delayed(_latency);
    AppLogger.debug('repository.mock', 'Returning ${_stories.length} stories');
    return List<StoryDetail>.unmodifiable(_stories);
  }

  @override
  Future<StoryDetail> fetchStoryById(int id) async {
    AppLogger.debug('repository.mock', 'Fetching mock story id=$id');
    await Future<void>.delayed(_latency);
    final story = _stories.firstWhere(
      (story) => story.id == id,
      orElse: () => throw StateError('Story not found: $id'),
    );
    AppLogger.debug(
      'repository.mock',
      'Found mock story id=${story.id} pages=${story.pages.length}',
    );
    return story;
  }
}
