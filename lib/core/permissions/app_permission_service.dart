import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

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
      if (current.isGranted) return AppMicrophonePermissionStatus.granted;
      if (current.isPermanentlyDenied) {
        return AppMicrophonePermissionStatus.permanentlyDenied;
      }
      if (current.isRestricted) return AppMicrophonePermissionStatus.restricted;

      final requested = await Permission.microphone.request();
      if (requested.isGranted) return AppMicrophonePermissionStatus.granted;
      if (requested.isPermanentlyDenied) {
        return AppMicrophonePermissionStatus.permanentlyDenied;
      }
      if (requested.isRestricted) {
        return AppMicrophonePermissionStatus.restricted;
      }

      return AppMicrophonePermissionStatus.denied;
    } on PlatformException {
      return AppMicrophonePermissionStatus.unavailable;
    }
  }
}
