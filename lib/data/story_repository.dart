import '../models/story.dart';
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
    await Future<void>.delayed(_latency);
    return List<StoryDetail>.unmodifiable(_stories);
  }

  @override
  Future<StoryDetail> fetchStoryById(int id) async {
    await Future<void>.delayed(_latency);
    return _stories.firstWhere(
      (story) => story.id == id,
      orElse: () => throw StateError('Story not found: $id'),
    );
  }
}
