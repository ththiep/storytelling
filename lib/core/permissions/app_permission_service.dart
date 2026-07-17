import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../logging/app_logger.dart';

enum AppMicrophonePermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
  unavailable,
}

class AppPermissionService {
  const AppPermissionService();

  Future<AppMicrophonePermissionStatus> requestMicrophoneForRecording() async {
    try {
      final current = await Permission.microphone.status;
      AppLogger.info('permission', 'Current microphone status: $current');
      if (current.isGranted) return AppMicrophonePermissionStatus.granted;
      if (current.isPermanentlyDenied) {
        return AppMicrophonePermissionStatus.permanentlyDenied;
      }
      if (current.isRestricted) return AppMicrophonePermissionStatus.restricted;

      final requested = await Permission.microphone.request();
      AppLogger.info('permission', 'Requested microphone status: $requested');
      if (requested.isGranted) return AppMicrophonePermissionStatus.granted;
      if (requested.isPermanentlyDenied) {
        return AppMicrophonePermissionStatus.permanentlyDenied;
      }
      if (requested.isRestricted) {
        return AppMicrophonePermissionStatus.restricted;
      }

      return AppMicrophonePermissionStatus.denied;
    } on PlatformException catch (error, stackTrace) {
      AppLogger.warning(
        'permission',
        'Microphone permission unavailable',
        error: error,
        stackTrace: stackTrace,
      );
      return AppMicrophonePermissionStatus.unavailable;
    }
  }
}
