import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:storytelling/core/audio/audio_engine.dart';
import 'package:storytelling/core/audio/narration_events.dart';
import 'package:storytelling/core/utils/word_timing_utils.dart';
import 'package:storytelling/features/catalog/data/story_repository.dart';
import 'package:storytelling/features/reading/application/story_reader_bloc.dart';
import 'package:storytelling/features/reading/application/story_reader_event.dart';
import 'package:storytelling/features/reading/application/story_reader_state.dart';
import 'package:storytelling/shared/models/story.dart';

void main() {
  test('pauses at current page end when auto page is off', () async {
    final audio = _FakeAudioEngine();
    final bloc = StoryReaderBloc(
      repository: _FakeStoryRepository(_story),
      audioEngine: audio,
    );

    bloc.add(const StoryReaderStarted(1));
    await _waitForReadyState(bloc, (state) => state.isSpeaking);

    bloc.add(const StoryReaderAutoTurnPageToggled(false));
    await _waitForReadyState(bloc, (state) => !state.autoTurnPage);

    audio.emit(
      const NarrationTimelineProgress(
        positionMs: 4100,
        pageIndex: 1,
        wordIndex: 0,
      ),
    );
    final paused = await _waitForReadyState(bloc, (state) => state.isPaused);
    await Future<void>.delayed(Duration.zero);

    expect(paused.pageIndex, 0);
    expect(paused.activeWordIndex, 1);
    expect(audio.pauseCount, 1);
    expect(audio.seekPositions, [4000]);

    await bloc.close();
  });
}

Future<StoryReaderReady> _waitForReadyState(
  StoryReaderBloc bloc,
  bool Function(StoryReaderReady state) test,
) async {
  final current = bloc.state;
  if (current is StoryReaderReady && test(current)) return current;

  return bloc.stream
      .where((state) => state is StoryReaderReady && test(state))
      .cast<StoryReaderReady>()
      .first;
}

class _FakeStoryRepository implements StoryRepository {
  const _FakeStoryRepository(this.story);

  final StoryDetail story;

  @override
  Future<StoryDetail> fetchStoryById(int id) async => story;

  @override
  Future<List<StoryDetail>> fetchStories() async => [story];
}

class _FakeAudioEngine implements AudioEngine {
  final _controller = StreamController<NarrationEvent>.broadcast();
  final List<int> seekPositions = [];
  int pauseCount = 0;

  @override
  Stream<NarrationEvent> get events => _controller.stream;

  void emit(NarrationEvent event) {
    _controller.add(event);
  }

  @override
  Future<void> prepare() async {}

  @override
  Future<void> play(StoryPlayback playback) async {}

  @override
  Future<void> pause() async {
    pauseCount += 1;
    _controller.add(const NarrationPaused());
  }

  @override
  Future<void> resume() async {}

  @override
  Future<void> seekTo(int positionMs) async {
    seekPositions.add(positionMs);
  }

  @override
  Future<void> stop() async {}

  @override
  Future<void> dispose() async {
    await _controller.close();
  }
}

const _story = StoryDetail(
  id: 1,
  title: 'Test Story',
  author: 'Tester',
  overview: 'A short test story',
  level: 1,
  durationMinutes: 1,
  imageUrl: 'assets/story.png',
  license: 'test',
  voices: [
    StoryVoice(
      voiceStyle: 'default',
      audioUrl: 'assets/audio/test.mp3',
      durationSeconds: 8,
    ),
  ],
  addedToChildren: [],
  status: 'published',
  isFavorite: false,
  progressSeconds: 0,
  pages: [
    StoryPage(
      pageNumber: 1,
      imageUrl: 'assets/page-1.png',
      startTimeMs: 0,
      endTimeMs: 4000,
      lines: [
        StoryLine(
          startTimeMs: 0,
          endTimeMs: 4000,
          fullText: 'One two',
          words: [
            StoryWord(word: 'One', startTimeMs: 0, endTimeMs: 1500),
            StoryWord(word: 'two', startTimeMs: 2000, endTimeMs: 4000),
          ],
        ),
      ],
    ),
    StoryPage(
      pageNumber: 2,
      imageUrl: 'assets/page-2.png',
      startTimeMs: 4001,
      endTimeMs: 8000,
      lines: [
        StoryLine(
          startTimeMs: 4001,
          endTimeMs: 8000,
          fullText: 'Three four',
          words: [
            StoryWord(word: 'Three', startTimeMs: 4001, endTimeMs: 5500),
            StoryWord(word: 'four', startTimeMs: 6000, endTimeMs: 8000),
          ],
        ),
      ],
    ),
  ],
);
