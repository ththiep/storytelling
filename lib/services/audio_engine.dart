import 'dart:async';

import 'package:just_audio/just_audio.dart';

import '../utils/word_timing_utils.dart';
import 'narration_engine.dart';

/// Plays story audio and emits page/word progress from page timelines.
class AudioEngine {
  AudioEngine() : _player = AudioPlayer();

  final AudioPlayer _player;
  final _controller = StreamController<NarrationEvent>.broadcast();

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;
  Timer? _completionFallback;

  bool _speaking = false;
  int _sessionId = 0;
  int _lastPageIndex = -1;
  int _lastWordIndex = -1;
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

    _positionSub = _player.positionStream.listen((position) {
      if (!_speaking || session != _sessionId) return;
      _emitProgress(position.inMilliseconds);
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

  void _emitProgress(int positionMs) {
    final playback = _playback;
    if (playback == null) return;

    final pageIndex = pageIndexAt(playback.pages, positionMs);
    final page = playback.pages.isEmpty ? null : playback.pages[pageIndex];
    final wordIndex = page == null
        ? -1
        : wordIndexAt(page.allWords, positionMs);

    if (pageIndex == _lastPageIndex && wordIndex == _lastWordIndex) return;
    _lastPageIndex = pageIndex;
    _lastWordIndex = wordIndex;
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
    _emitProgress(clampedPosition);
  }

  Future<void> stop() async {
    _sessionId += 1;
    _speaking = false;
    _lastPageIndex = -1;
    _lastWordIndex = -1;
    _playback = null;
    _completionFallback?.cancel();
    _completionFallback = null;
    await _cancelSubscriptions();
    await _player.stop();
  }

  Future<void> _cancelSubscriptions() async {
    await _positionSub?.cancel();
    await _stateSub?.cancel();
    _positionSub = null;
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
