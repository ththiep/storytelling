class StoryWord {
  const StoryWord({
    required this.word,
    required this.startTimeMs,
    required this.endTimeMs,
  });

  final String word;
  final int startTimeMs;
  final int endTimeMs;
}

class StoryLine {
  const StoryLine({
    required this.startTimeMs,
    required this.endTimeMs,
    required this.fullText,
    required this.words,
  });

  final int startTimeMs;
  final int endTimeMs;
  final String fullText;
  final List<StoryWord> words;
}

class StoryPage {
  const StoryPage({
    required this.pageNumber,
    required this.imageUrl,
    required this.startTimeMs,
    required this.endTimeMs,
    required this.lines,
  });

  final int pageNumber;
  final String imageUrl;
  final int startTimeMs;
  final int endTimeMs;
  final List<StoryLine> lines;

  String get displayText => lines.map((line) => line.fullText).join('\n');

  List<StoryWord> get allWords =>
      lines.expand((line) => line.words).toList(growable: false);
}

class StoryVoice {
  const StoryVoice({
    required this.voiceStyle,
    required this.audioUrl,
    required this.durationSeconds,
  });

  final String voiceStyle;
  final String audioUrl;
  final int durationSeconds;

  bool get isNetworkAudio =>
      audioUrl.startsWith('http://') || audioUrl.startsWith('https://');
}

class StoryDetail {
  const StoryDetail({
    required this.id,
    required this.title,
    required this.author,
    required this.overview,
    required this.level,
    required this.durationMinutes,
    required this.imageUrl,
    required this.license,
    required this.voices,
    required this.addedToChildren,
    required this.status,
    required this.isFavorite,
    required this.progressSeconds,
    this.textUrl,
    this.lastPlayedAt,
    this.pages = const [],
  });

  final int id;
  final String title;
  final String author;
  final String overview;
  final int level;
  final int durationMinutes;
  final String imageUrl;
  final String? textUrl;
  final String license;
  final List<StoryVoice> voices;
  final List<String> addedToChildren;
  final String status;
  final bool isFavorite;
  final int progressSeconds;
  final DateTime? lastPlayedAt;

  /// Paginated karaoke content aligned to the primary voice timeline.
  final List<StoryPage> pages;

  StoryVoice? voiceByStyle(String style) {
    for (final voice in voices) {
      if (voice.voiceStyle == style) return voice;
    }
    return null;
  }

  StoryVoice? get primaryVoice => voices.isEmpty ? null : voices.first;

  bool get hasPages => pages.isNotEmpty;
}
