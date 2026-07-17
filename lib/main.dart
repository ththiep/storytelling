import 'package:flutter/material.dart';

import 'app/di/injection_container.dart';
import 'app/storytelling_app.dart';
import 'core/permissions/app_permission_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  await getIt<AppPermissionService>().requestMicrophoneForRecording();
  runApp(const StorytellingApp());
}
