import 'package:flutter/material.dart';

import 'app/di/injection_container.dart';
import 'app/storytelling_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const StorytellingApp());
}
