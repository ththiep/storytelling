import 'package:flutter_test/flutter_test.dart';
import 'package:storytelling/shared/models/story.dart';
import 'package:storytelling/core/utils/word_timing_utils.dart';

void main() {
  test('pageIndexAt and wordIndexAt follow page timelines', () {
    const pages = [
      StoryPage(
        pageNumber: 1,
        imageUrl: 'assets/a.png',
        startTimeMs: 0,
        endTimeMs: 4000,
        lines: [
          StoryLine(
            startTimeMs: 500,
            endTimeMs: 3500,
            fullText: 'Too Big!',
            words: [
              StoryWord(word: 'Too', startTimeMs: 500, endTimeMs: 1000),
              StoryWord(word: 'Big!', startTimeMs: 1300, endTimeMs: 1900),
              StoryWord(word: 'She', startTimeMs: 2000, endTimeMs: 2020),
              StoryWord(word: 'stretches', startTimeMs: 2020, endTimeMs: 2600),
            ],
          ),
        ],
      ),
      StoryPage(
        pageNumber: 2,
        imageUrl: 'assets/b.png',
        startTimeMs: 4500,
        endTimeMs: 10000,
        lines: [
          StoryLine(
            startTimeMs: 4500,
            endTimeMs: 6800,
            fullText: 'Shanu is',
            words: [
              StoryWord(word: 'Shanu', startTimeMs: 4500, endTimeMs: 5100),
              StoryWord(word: 'is', startTimeMs: 5200, endTimeMs: 5500),
            ],
          ),
        ],
      ),
    ];

    expect(pageIndexAt(pages, 1000), 0);
    expect(pageIndexAt(pages, 4250), 0);
    expect(pageIndexAt(pages, 5000), 1);
    expect(wordIndexAt(pages[0].allWords, 250), -1);
    expect(wordIndexAt(pages[0].allWords, 1050), 0);
    expect(wordIndexAt(pages[0].allWords, 1200), 0);
    expect(wordIndexAt(pages[0].allWords, 1400), 1);
    expect(wordIndexAt(pages[0].allWords, 2030), 2);
    expect(wordIndexAt(pages[0].allWords, 2200), 3);
    expect(wordIndexAt(pages[1].allWords, 5300), 1);
  });
}
