import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/catalog/presentation/bloc/story_list_bloc.dart';
import '../features/catalog/presentation/bloc/story_list_event.dart';
import '../features/catalog/presentation/home_screen.dart';
import 'di/injection_container.dart';
import 'theme/theme_manager.dart';

class StorytellingApp extends StatelessWidget {
  const StorytellingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoryListBloc>()..add(const StoryListStarted()),
      child: MaterialApp(
        title: 'Kể chuyện',
        debugShowCheckedModeBanner: false,
        theme: ThemeManager.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
