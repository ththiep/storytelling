import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../logging/app_logger.dart';

class StoryVoiceRecordingService {
  StoryVoiceRecordingService({AudioRecorder? recorder, AudioPlayer? player})
    : _recorder = recorder ?? AudioRecorder(),
      _player = player ?? AudioPlayer();

  static const _minimumUsableRecordingBytes = 1024;

  final AudioRecorder _recorder;
  final AudioPlayer _player;

  Future<File?> latestRecording({
    required int storyId,
    required int pageNumber,
  }) async {
    final file = await _latestRecordingFile(
      storyId: storyId,
      pageNumber: pageNumber,
    );
    AppLogger.debug(
      'recording',
      'Latest recording lookup story=$storyId page=$pageNumber '
          'exists=${file.existsSync()} size=${_fileSize(file)} path=${file.path}',
    );
    return file.existsSync() ? file : null;
  }

  Future<void> startPageRecording({
    required int storyId,
    required int pageNumber,
  }) async {
    final tempFile = await _recordingTempFile(
      storyId: storyId,
      pageNumber: pageNumber,
    );
    AppLogger.info(
      'recording',
      'Starting recording story=$storyId page=$pageNumber path=${tempFile.path}',
    );
    await tempFile.parent.create(recursive: true);

    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
    await _player.stop();
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 64000,
        sampleRate: 44100,
        numChannels: 1,
      ),
      path: tempFile.path,
    );
  }

  Future<File?> stopPageRecording({
    required int storyId,
    required int pageNumber,
  }) async {
    AppLogger.info(
      'recording',
      'Stopping recording story=$storyId page=$pageNumber',
    );
    final path = await _recorder.stop();
    if (path == null) {
      AppLogger.warning('recording', 'Recorder returned null path');
      return null;
    }

    final tempFile = File(path);
    if (!tempFile.existsSync()) {
      AppLogger.warning('recording', 'Temp recording file missing path=$path');
      return null;
    }

    final latestFile = await _latestRecordingFile(
      storyId: storyId,
      pageNumber: pageNumber,
    );
    final tempSize = tempFile.lengthSync();
    if (tempSize < _minimumUsableRecordingBytes) {
      AppLogger.warning(
        'recording',
        'Discarding too-small recording size=$tempSize path=${tempFile.path}',
      );
      await tempFile.delete();
      return latestFile.existsSync() ? latestFile : null;
    }

    await latestFile.parent.create(recursive: true);
    if (latestFile.existsSync()) {
      await latestFile.delete();
    }
    final file = await tempFile.rename(latestFile.path);
    AppLogger.info(
      'recording',
      'Saved latest recording size=${file.lengthSync()} path=${file.path}',
    );
    return file;
  }

  Future<void> playPageRecording({
    required int storyId,
    required int pageNumber,
  }) async {
    final file = await latestRecording(
      storyId: storyId,
      pageNumber: pageNumber,
    );
    if (file == null) {
      AppLogger.warning(
        'recording',
        'No recording found story=$storyId page=$pageNumber',
      );
      throw StateError('No recording for story $storyId page $pageNumber');
    }

    AppLogger.info(
      'recording',
      'Playing recording size=${file.lengthSync()} path=${file.path}',
    );
    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
    await _player.stop();
    final duration = await _player.setFilePath(file.path);
    AppLogger.info(
      'recording',
      'Recording prepared durationMs=${duration?.inMilliseconds}',
    );
    await _player.play();
    AppLogger.info('recording', 'Recording playback completed');
  }

  Future<void> stopPlayback() async {
    AppLogger.debug('recording', 'Stopping recording playback');
    await _player.stop();
  }

  Future<void> cancelRecording() async {
    if (await _recorder.isRecording()) {
      AppLogger.info('recording', 'Cancelling active recording');
      await _recorder.cancel();
    }
  }

  Future<void> dispose() async {
    AppLogger.debug('recording', 'Disposing recording service');
    await cancelRecording();
    await _player.dispose();
    await _recorder.dispose();
  }

  Future<File> _latestRecordingFile({
    required int storyId,
    required int pageNumber,
  }) async {
    final documents = await getApplicationDocumentsDirectory();
    return File(
      '${documents.path}/recordings/story_$storyId/page_$pageNumber/latest.m4a',
    );
  }

  Future<File> _recordingTempFile({
    required int storyId,
    required int pageNumber,
  }) async {
    final documents = await getApplicationDocumentsDirectory();
    return File(
      '${documents.path}/recordings/story_$storyId/page_$pageNumber/recording.m4a',
    );
  }

  int? _fileSize(File file) {
    return file.existsSync() ? file.lengthSync() : null;
  }
}
