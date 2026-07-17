import 'dart:async';

import 'package:just_audio/just_audio.dart';

import '../logging/app_logger.dart';
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
    AppLogger.debug('audio', 'Preparing audio engine');
    await _player.setVolume(1);
  }

  Future<void> play(StoryPlayback playback) async {
    final session = ++_sessionId;
    AppLogger.info(
      'audio',
      'Starting playback session=$session '
          'source=${playback.isNetworkAudio ? 'network' : 'asset'} '
          'durationMs=${playback.durationMs} pages=${playback.pages.length}',
    );
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
    if (session != _sessionId) {
      AppLogger.debug('audio', 'Ignoring stale play session=$session');
      return;
    }

    _positionTimer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      if (!_speaking || session != _sessionId) return;
      _emitProgress(_player.position.inMilliseconds);
    });

    _stateSub = _player.playerStateStream.listen((state) {
      if (session != _sessionId) return;
      if (state.processingState == ProcessingState.completed) {
        AppLogger.info('audio', 'Player completed session=$session');
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
      AppLogger.debug(
        'karaoke',
        'Ignored stale positionMs=$positionMs lastPositionMs=$_lastPositionMs',
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
    AppLogger.debug(
      'karaoke',
      'positionMs=$positionMs pageIndex=$pageIndex '
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
    AppLogger.info('audio', 'Pausing playback at ${_player.position}');
    _speaking = false;
    await _player.pause();
    _controller.add(const NarrationPaused());
  }

  Future<void> resume() async {
    AppLogger.info('audio', 'Resuming playback at ${_player.position}');
    _speaking = true;
    await _player.play();
  }

  Future<void> seekTo(int positionMs) async {
    final playback = _playback;
    if (playback == null) return;

    final clampedPosition = positionMs.clamp(0, playback.durationMs);
    AppLogger.info('audio', 'Seeking to ${clampedPosition}ms');
    await _player.seek(Duration(milliseconds: clampedPosition));
    _lastPositionMs = clampedPosition;
    _emitProgress(clampedPosition, allowBackward: true);
  }

  Future<void> stop() async {
    AppLogger.info('audio', 'Stopping playback session=$_sessionId');
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
    AppLogger.info('audio', 'Emitting playback completed');
    _speaking = false;
    _completionFallback?.cancel();
    _completionFallback = null;
    _controller.add(const NarrationCompleted());
  }

  Future<void> dispose() async {
    AppLogger.debug('audio', 'Disposing audio engine');
    await stop();
    await _controller.close();
    await _player.dispose();
  }
}
