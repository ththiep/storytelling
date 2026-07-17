import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../features/catalog/presentation/bloc/story_list_bloc.dart';
import '../features/catalog/presentation/bloc/story_list_event.dart';
import '../features/catalog/presentation/home_screen.dart';
import 'di/injection_container.dart';
import 'theme/theme_manager.dart';
import 'package:storytelling/l10n/app_localizations.dart';

class StorytellingApp extends StatelessWidget {
  const StorytellingApp({super.key, this.locale});

  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoryListBloc>()..add(const StoryListStarted()),
      child: MaterialApp(
        locale: locale,
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeManager.lightTheme,
        home: const HomeScreen(),
      ),
    );
  }
}
