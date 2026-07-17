import 'package:dio/dio.dart';

import '../dto/story_dto.dart';

/// REST client for story endpoints.
class StoryApiService {
  StoryApiService(this._dio);

  final Dio _dio;

  Future<List<StoryDetailDto>> fetchStories() async {
    final response = await _dio.get<dynamic>('/stories');
    final payload = response.data;

    final list = switch (payload) {
      final List items => items,
      final Map<String, dynamic> map when map['data'] is List =>
        map['data'] as List,
      _ => throw const FormatException(
          'Expected a JSON array (or {data: []}) for /stories',
        ),
    };

    return list
        .map((item) => StoryDetailDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<StoryDetailDto> fetchStoryById(int id) async {
    final response = await _dio.get<dynamic>('/stories/$id');
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      throw const FormatException(
        'Expected a JSON object (or {data: {}}) for /stories/:id',
      );
    }
    return StoryDetailDto.fromResponse(data);
  }
}
