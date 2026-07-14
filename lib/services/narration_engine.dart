sealed class NarrationEvent {
  const NarrationEvent();
}

class NarrationStarted extends NarrationEvent {
  const NarrationStarted();
}

class NarrationTimelineProgress extends NarrationEvent {
  const NarrationTimelineProgress({
    required this.positionMs,
    required this.pageIndex,
    required this.wordIndex,
  });

  final int positionMs;
  final int pageIndex;
  final int wordIndex;
}

class NarrationCompleted extends NarrationEvent {
  const NarrationCompleted();
}

class NarrationPaused extends NarrationEvent {
  const NarrationPaused();
}
