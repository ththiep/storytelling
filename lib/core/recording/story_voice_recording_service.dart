import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class StoryVoiceRecordingService {
  StoryVoiceRecordingService({AudioRecorder? recorder, AudioPlayer? player})
    : _recorder = recorder ?? AudioRecorder(),
      _player = player ?? AudioPlayer();

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
    final path = await _recorder.stop();
    if (path == null) return null;

    final tempFile = File(path);
    if (!tempFile.existsSync()) return null;

    final latestFile = await _latestRecordingFile(
      storyId: storyId,
      pageNumber: pageNumber,
    );
    await latestFile.parent.create(recursive: true);
    if (latestFile.existsSync()) {
      await latestFile.delete();
    }
    return tempFile.rename(latestFile.path);
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
      throw StateError('No recording for story $storyId page $pageNumber');
    }

    if (await _recorder.isRecording()) {
      await _recorder.stop();
    }
    await _player.stop();
    await _player.setFilePath(file.path);
    await _player.play();
  }

  Future<void> stopPlayback() async {
    await _player.stop();
  }

  Future<void> cancelRecording() async {
    if (await _recorder.isRecording()) {
      await _recorder.cancel();
    }
  }

  Future<void> dispose() async {
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
}
