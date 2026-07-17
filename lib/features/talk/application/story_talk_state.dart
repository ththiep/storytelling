import 'package:equatable/equatable.dart';

import 'package:storytelling/shared/models/story.dart';

enum TalkStatus { ready, recording, busy }

enum TalkNotice { recordingFailed, playbackFailed }

final class StoryTalkState extends Equatable {
  const StoryTalkState({
    required this.story,
    required this.pages,
    required this.pageIndex,
    required this.status,
    required this.hasRecording,
    required this.practicedPageIndexes,
    this.notice,
  });

  factory StoryTalkState.initial(StoryDetail story) {
    final pages = [...story.pages]
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
    return StoryTalkState(
      story: story,
      pages: pages,
      pageIndex: 0,
      status: TalkStatus.busy,
      hasRecording: false,
      practicedPageIndexes: const <int>{},
    );
  }

  final StoryDetail story;
  final List<StoryPage> pages;
  final int pageIndex;
  final TalkStatus status;
  final bool hasRecording;
  final Set<int> practicedPageIndexes;
  final TalkNotice? notice;

  StoryPage? get currentPage => pages.isEmpty ? null : pages[pageIndex];
  bool get isRecording => status == TalkStatus.recording;
  bool get isBusy => status == TalkStatus.busy;
  bool get isComplete =>
      pages.isNotEmpty && practicedPageIndexes.length == pages.length;

  StoryTalkState copyWith({
    int? pageIndex,
    TalkStatus? status,
    bool? hasRecording,
    Set<int>? practicedPageIndexes,
    TalkNotice? notice,
    bool clearNotice = false,
  }) {
    return StoryTalkState(
      story: story,
      pages: pages,
      pageIndex: pageIndex ?? this.pageIndex,
      status: status ?? this.status,
      hasRecording: hasRecording ?? this.hasRecording,
      practicedPageIndexes: practicedPageIndexes ?? this.practicedPageIndexes,
      notice: clearNotice ? null : notice ?? this.notice,
    );
  }

  @override
  List<Object?> get props => [
    story.id,
    pages.length,
    pageIndex,
    status,
    hasRecording,
    practicedPageIndexes,
    notice,
  ];
}
