import 'dart:async';

import 'package:just_audio/just_audio.dart';

import '../utils/word_timing_utils.dart';
import 'narration_events.dart';

/// Plays story audio and emits page/word progress from page timelines.
class AudioEngine {
  AudioEngine() : _player = AudioPlayer();

  final AudioPlayer _player;
  final _controller = StreamController<NarrationEvent>.broadcast();

  StreamSubscription<PlayerState>? _stateSub;
  Timer? _positionTimer;
  Timer? _completionFallback;

  bool _speaking = false;
  int _sessionId = 0;
  int _lastPageIndex = -1;
  int _lastWordIndex = -1;
  int _lastPositionMs = -1;
  StoryPlayback? _playback;

  Stream<NarrationEvent> get events => _controller.stream;

  Future<void> prepare() async {
    await _player.setVolume(1);
  }

  Future<void> play(StoryPlayback playback) async {
    final session = ++_sessionId;
    _playback = playback;
    _lastPageIndex = -1;
    _lastWordIndex = -1;
    _lastPositionMs = -1;
    _speaking = true;

    _completionFallback?.cancel();
    await _cancelSubscriptions();
    await _player.stop();

    if (playback.isNetworkAudio) {
      await _player.setUrl(playback.audioSource);
    } else {
      await _player.setAsset(playback.audioSource);
    }
    if (session != _sessionId) return;

    _positionTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_speaking || session != _sessionId) return;
      _emitProgress(_player.position.inMilliseconds);
    });

    _stateSub = _player.playerStateStream.listen((state) {
      if (session != _sessionId) return;
      if (state.processingState == ProcessingState.completed) {
        _emitCompleted();
      }
    });

    _controller.add(const NarrationStarted());
    _emitProgress(0);

    _completionFallback = Timer(
      Duration(milliseconds: playback.durationMs + 250),
      () {
        if (session != _sessionId || !_speaking) return;
        _emitCompleted();
      },
    );

    await _player.play();
  }

  void _emitProgress(int positionMs, {bool allowBackward = false}) {
    final playback = _playback;
    if (playback == null) return;
    if (!allowBackward &&
        _lastPositionMs >= 0 &&
        positionMs < _lastPositionMs - 250) {
      // just_audio can briefly report an older playback event after loading or
      // buffering. Dropping it keeps karaoke from jumping back mid-sentence.
      // ignore: avoid_print
      print(
        '[karaoke] ignored stale positionMs=$positionMs '
        'lastPositionMs=$_lastPositionMs',
      );
      return;
    }

    final pageIndex = pageIndexAt(playback.pages, positionMs);
    final page = playback.pages.isEmpty ? null : playback.pages[pageIndex];
    final wordIndex = page == null
        ? -1
        : wordIndexAt(page.allWords, positionMs);

    if (pageIndex == _lastPageIndex && wordIndex == _lastWordIndex) return;
    final word =
        page == null || wordIndex < 0 || wordIndex >= page.allWords.length
        ? '-'
        : page.allWords[wordIndex].word;
    // Keep this log while tuning karaoke sync. It only fires when page/word changes.
    // ignore: avoid_print
    print(
      '[karaoke] positionMs=$positionMs pageIndex=$pageIndex '
      'wordIndex=$wordIndex word="$word"',
    );
    _lastPageIndex = pageIndex;
    _lastWordIndex = wordIndex;
    _lastPositionMs = positionMs;
    _controller.add(
      NarrationTimelineProgress(
        positionMs: positionMs,
        pageIndex: pageIndex,
        wordIndex: wordIndex,
      ),
    );
  }

  Future<void> pause() async {
    if (!_speaking) return;
    _speaking = false;
    await _player.pause();
    _controller.add(const NarrationPaused());
  }

  Future<void> resume() async {
    _speaking = true;
    await _player.play();
  }

  Future<void> seekTo(int positionMs) async {
    final playback = _playback;
    if (playback == null) return;

    final clampedPosition = positionMs.clamp(0, playback.durationMs);
    await _player.seek(Duration(milliseconds: clampedPosition));
    _lastPositionMs = clampedPosition;
    _emitProgress(clampedPosition, allowBackward: true);
  }

  Future<void> stop() async {
    _sessionId += 1;
    _speaking = false;
    _lastPageIndex = -1;
    _lastWordIndex = -1;
    _lastPositionMs = -1;
    _playback = null;
    _completionFallback?.cancel();
    _completionFallback = null;
    await _cancelSubscriptions();
    await _player.stop();
  }

  Future<void> _cancelSubscriptions() async {
    _positionTimer?.cancel();
    await _stateSub?.cancel();
    _positionTimer = null;
    _stateSub = null;
  }

  void _emitCompleted() {
    if (!_speaking) return;
    _speaking = false;
    _completionFallback?.cancel();
    _completionFallback = null;
    _controller.add(const NarrationCompleted());
  }

  Future<void> dispose() async {
    await stop();
    await _controller.close();
    await _player.dispose();
  }
}
