import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/story_list/story_list_bloc.dart';
import 'bloc/story_list/story_list_event.dart';
import 'di/injection_container.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const StorytellingApp());
}

class StorytellingApp extends StatelessWidget {
  const StorytellingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoryListBloc>()..add(const StoryListStarted()),
      child: MaterialApp(
        title: 'Kể chuyện',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFC45C26),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
