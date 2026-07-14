import '../models/story.dart';

const _minWordDisplayDurationMs = 160;

int pageIndexAt(List<StoryPage> pages, int positionMs) {
  if (pages.isEmpty) return 0;
  if (positionMs < pages.first.startTimeMs) return 0;
  for (var i = 0; i < pages.length; i++) {
    final page = pages[i];
    if (positionMs >= page.startTimeMs && positionMs <= page.endTimeMs) {
      return i;
    }
    if (i > 0 && positionMs < page.startTimeMs) {
      return i - 1;
    }
  }
  return pages.length - 1;
}

int wordIndexAt(List<StoryWord> words, int positionMs) {
  if (words.isEmpty) return -1;
  if (positionMs < words.first.startTimeMs) return -1;
  for (var i = 0; i < words.length; i++) {
    final word = words[i];
    final effectiveEndTimeMs = word.endTimeMs < word.startTimeMs
        ? word.startTimeMs + _minWordDisplayDurationMs
        : word.endTimeMs;
    final displayEndTimeMs =
        effectiveEndTimeMs - word.startTimeMs < _minWordDisplayDurationMs
        ? word.startTimeMs + _minWordDisplayDurationMs
        : effectiveEndTimeMs;
    if (positionMs >= word.startTimeMs && positionMs < displayEndTimeMs) {
      return i;
    }
    if (i > 0 && positionMs < word.startTimeMs) {
      return i - 1;
    }
  }
  return words.length - 1;
}

class StoryPlayback {
  const StoryPlayback({
    required this.audioSource,
    required this.durationMs,
    required this.pages,
  });

  final String audioSource;
  final int durationMs;
  final List<StoryPage> pages;

  bool get isNetworkAudio =>
      audioSource.startsWith('http://') || audioSource.startsWith('https://');

  factory StoryPlayback.fromDetail(StoryDetail story, {String? voiceStyle}) {
    final voice = voiceStyle == null
        ? story.primaryVoice
        : story.voiceByStyle(voiceStyle) ?? story.primaryVoice;
    if (voice == null) {
      throw StateError('Story ${story.id} has no voices');
    }

    return StoryPlayback(
      audioSource: voice.audioUrl,
      durationMs: voice.durationSeconds * 1000,
      pages: story.pages,
    );
  }
}
