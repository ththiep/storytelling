import 'package:storytelling/shared/models/story.dart';

class StoryWordDto {
  const StoryWordDto({
    required this.word,
    required this.startTimeMs,
    required this.endTimeMs,
  });

  final String word;
  final int startTimeMs;
  final int endTimeMs;

  factory StoryWordDto.fromJson(Map<String, dynamic> json) {
    return StoryWordDto(
      word: json['word'] as String,
      startTimeMs: (json['start_time_ms'] ?? json['startTimeMs']) as int,
      endTimeMs: (json['end_time_ms'] ?? json['endTimeMs']) as int,
    );
  }

  StoryWord toDomain() => StoryWord(
        word: word,
        startTimeMs: startTimeMs,
        endTimeMs: endTimeMs,
      );
}

class StoryLineDto {
  const StoryLineDto({
    required this.startTimeMs,
    required this.endTimeMs,
    required this.fullText,
    required this.words,
  });

  final int startTimeMs;
  final int endTimeMs;
  final String fullText;
  final List<StoryWordDto> words;

  factory StoryLineDto.fromJson(Map<String, dynamic> json) {
    final wordsJson = json['words'] as List<dynamic>? ?? const [];
    return StoryLineDto(
      startTimeMs: (json['start_time_ms'] ?? json['startTimeMs']) as int,
      endTimeMs: (json['end_time_ms'] ?? json['endTimeMs']) as int,
      fullText: (json['full_text'] ?? json['fullText']) as String,
      words: wordsJson
          .map((e) => StoryWordDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  StoryLine toDomain() => StoryLine(
        startTimeMs: startTimeMs,
        endTimeMs: endTimeMs,
        fullText: fullText,
        words: words.map((w) => w.toDomain()).toList(),
      );
}

class StoryPageDto {
  const StoryPageDto({
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
  final List<StoryLineDto> lines;

  factory StoryPageDto.fromJson(Map<String, dynamic> json) {
    final linesJson = json['lines'] as List<dynamic>? ?? const [];
    return StoryPageDto(
      pageNumber: (json['page_number'] ?? json['pageNumber']) as int,
      imageUrl: (json['image_url'] ?? json['imageUrl']) as String,
      startTimeMs: (json['start_time_ms'] ?? json['startTimeMs']) as int,
      endTimeMs: (json['end_time_ms'] ?? json['endTimeMs']) as int,
      lines: linesJson
          .map((e) => StoryLineDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  StoryPage toDomain() => StoryPage(
        pageNumber: pageNumber,
        imageUrl: imageUrl,
        startTimeMs: startTimeMs,
        endTimeMs: endTimeMs,
        lines: lines.map((l) => l.toDomain()).toList(),
      );
}

class StoryVoiceDto {
  const StoryVoiceDto({
    required this.voiceStyle,
    required this.audioUrl,
    required this.durationSeconds,
  });

  final String voiceStyle;
  final String audioUrl;
  final int durationSeconds;

  factory StoryVoiceDto.fromJson(Map<String, dynamic> json) {
    return StoryVoiceDto(
      voiceStyle: json['voice_style'] as String,
      audioUrl: json['audio_url'] as String,
      durationSeconds: json['duration_seconds'] as int,
    );
  }

  StoryVoice toDomain() => StoryVoice(
        voiceStyle: voiceStyle,
        audioUrl: audioUrl,
        durationSeconds: durationSeconds,
      );
}

class StoryDetailDto {
  const StoryDetailDto({
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
  final List<StoryVoiceDto> voices;
  final List<String> addedToChildren;
  final String status;
  final bool isFavorite;
  final int progressSeconds;
  final String? lastPlayedAt;
  final List<StoryPageDto> pages;

  factory StoryDetailDto.fromResponse(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is Map<String, dynamic>) {
      return StoryDetailDto.fromJson(data);
    }
    return StoryDetailDto.fromJson(json);
  }

  factory StoryDetailDto.fromJson(Map<String, dynamic> json) {
    final voicesJson = json['voices'] as List<dynamic>? ?? const [];
    final childrenJson = json['added_to_children'] as List<dynamic>? ?? const [];
    final pagesJson = json['pages'] as List<dynamic>? ?? const [];

    return StoryDetailDto(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      overview: json['overview'] as String,
      level: json['level'] as int,
      durationMinutes: json['duration_minutes'] as int,
      imageUrl: json['image_url'] as String,
      textUrl: json['text_url'] as String?,
      license: json['license'] as String,
      voices: voicesJson
          .map((e) => StoryVoiceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      addedToChildren: childrenJson.map((e) => e.toString()).toList(),
      status: json['status'] as String,
      isFavorite: json['is_favorite'] as bool? ?? false,
      progressSeconds: json['progress_seconds'] as int? ?? 0,
      lastPlayedAt: json['last_played_at'] as String?,
      pages: pagesJson
          .map((e) => StoryPageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  StoryDetail toDomain() => StoryDetail(
        id: id,
        title: title,
        author: author,
        overview: overview,
        level: level,
        durationMinutes: durationMinutes,
        imageUrl: imageUrl,
        textUrl: textUrl,
        license: license,
        voices: voices.map((v) => v.toDomain()).toList(),
        addedToChildren: addedToChildren,
        status: status,
        isFavorite: isFavorite,
        progressSeconds: progressSeconds,
        lastPlayedAt:
            lastPlayedAt == null ? null : DateTime.tryParse(lastPlayedAt!),
        pages: pages.map((p) => p.toDomain()).toList(),
      );
}
