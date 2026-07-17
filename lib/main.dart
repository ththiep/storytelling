import 'package:flutter/material.dart';

import 'app/di/injection_container.dart';
import 'app/storytelling_app.dart';
import 'core/logging/app_logger.dart';
import 'core/permissions/app_permission_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppLogger.info('app', 'Starting app bootstrap');
  await configureDependencies();
  final microphoneStatus = await getIt<AppPermissionService>()
      .requestMicrophoneForRecording();
  AppLogger.info('app', 'Microphone permission status: $microphoneStatus');
  AppLogger.info('app', 'Running StorytellingApp');
  runApp(const StorytellingApp());
}
