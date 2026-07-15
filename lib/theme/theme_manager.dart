import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'storytelling_theme.dart';

/// Central theme manager for app-wide colors, typography, and decorations.
class ThemeManager {
  ThemeManager._();

  static final StorytellingTheme _lightStorytellingTheme =
      StorytellingTheme.light();

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.brand500,
      brightness: Brightness.light,
      primary: AppColors.brand500,
      secondary: AppColors.orange500,
      surface: AppColors.white,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.yellow100,
      textTheme: AppTypography.textTheme(),
      extensions: [_lightStorytellingTheme],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.yellow100,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.sectionTitle(),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.storyCardBorder, width: 2),
        ),
        shadowColor: AppColors.storyCardShadow,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.backgroundAccentBoldBrand,
          foregroundColor: AppColors.textOnSolidPrimary,
          textStyle: AppTypography.bodyMedium(
            color: AppColors.textOnSolidPrimary,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(0, 44),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brand600,
          textStyle: AppTypography.bodyMedium(color: AppColors.brand600),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.textPrimary),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.orange500;
          }
          return AppColors.textDisabled;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.yellow300;
          }
          return AppColors.yellow100;
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDefault,
        thickness: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.brand500,
      ),
    );
  }

  static StorytellingTheme storytellingThemeOf(BuildContext context) {
    final theme = Theme.of(context).extension<StorytellingTheme>();
    assert(
      theme != null,
      'StorytellingTheme is missing. Did you register ThemeManager.lightTheme?',
    );
    return theme ?? _lightStorytellingTheme;
  }
}

extension StorytellingThemeContext on BuildContext {
  StorytellingTheme get storyTheme => ThemeManager.storytellingThemeOf(this);
}
