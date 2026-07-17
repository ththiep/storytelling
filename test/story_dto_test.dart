import 'package:flutter_test/flutter_test.dart';
import 'package:storytelling/features/catalog/data/dto/story_dto.dart';

void main() {
  test('StoryDetailDto parses detail with pages', () {
    final dto = StoryDetailDto.fromResponse({
      'data': {
        'id': 8,
        'title': 'Thánh Gióng',
        'author': 'Nguyệt Giang',
        'overview': 'Cậu bé làng Gióng...',
        'level': 1,
        'duration_minutes': 2,
        'image_url': 'assets/stories/thanh-giong/cover.jpg',
        'text_url': null,
        'license': 'CC-BY 4.0',
        'voices': [
          {
            'voice_style': 'voice_a',
            'audio_url': 'assets/stories/thanh-giong/audio.m4a',
            'duration_seconds': 10,
          },
        ],
        'added_to_children': ['019e629c-demo'],
        'status': 'in_progress',
        'is_favorite': true,
        'progress_seconds': 21,
        'last_played_at': '2026-07-14T04:43:03+00:00',
        'pages': [
          {
            'page_number': 1,
            'image_url': 'assets/stories/thanh-giong/pages/page_1.jpeg',
            'start_time_ms': 0,
            'end_time_ms': 4000,
            'lines': [
              {
                'start_time_ms': 500,
                'end_time_ms': 3500,
                'full_text': 'Thánh Gióng',
                'words': [
                  {'word': 'Thánh', 'start_time_ms': 500, 'end_time_ms': 1000},
                  {'word': 'Gióng', 'start_time_ms': 1100, 'end_time_ms': 1900},
                ],
              },
            ],
          },
        ],
      },
    });

    final story = dto.toDomain();
    expect(story.id, 8);
    expect(story.hasPages, isTrue);
    expect(story.pages, hasLength(1));
    expect(story.pages.first.lines.first.words.first.word, 'Thánh');
    expect(story.pages.first.allWords, hasLength(2));
  });
}
