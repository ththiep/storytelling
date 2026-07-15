import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// Semantic design tokens exposed through [ThemeExtension].
@immutable
class StorytellingTheme extends ThemeExtension<StorytellingTheme> {
  const StorytellingTheme({
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textDisabled,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceMuted,
    required this.brandPrimary,
    required this.brandSecondary,
    required this.accentYellow,
    required this.accentRed,
    required this.accentGreen,
    required this.accentPurple,
    required this.success,
    required this.error,
    required this.readingColor,
    required this.readingBackground,
    required this.playColor,
    required this.playBackground,
    required this.speakingColor,
    required this.speakingBackground,
    required this.homeBackground,
    required this.hubBackground,
    required this.readerBackground,
    required this.gameBackground,
    required this.appTitle,
    required this.screenTitle,
    required this.sectionTitle,
    required this.cardTitle,
    required this.modeTitle,
    required this.storyCardTitle,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.caption,
    required this.actionLabel,
    required this.badge,
    required this.karaoke,
    required this.karaokeActive,
    required this.karaokeDim,
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusLarge,
    required this.radiusPill,
    required this.radiusStoryCard,
    required this.radiusKidPanel,
    required this.cardShadow,
    required this.storyCardShadow,
    required this.elevatedShadow,
  });

  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textDisabled;
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceMuted;
  final Color brandPrimary;
  final Color brandSecondary;
  final Color accentYellow;
  final Color accentRed;
  final Color accentGreen;
  final Color accentPurple;
  final Color success;
  final Color error;

  final Color readingColor;
  final Color readingBackground;
  final Color playColor;
  final Color playBackground;
  final Color speakingColor;
  final Color speakingBackground;

  final LinearGradient homeBackground;
  final LinearGradient hubBackground;
  final LinearGradient readerBackground;
  final LinearGradient gameBackground;

  final TextStyle appTitle;
  final TextStyle screenTitle;
  final TextStyle sectionTitle;
  final TextStyle cardTitle;
  final TextStyle modeTitle;
  final TextStyle storyCardTitle;
  final TextStyle bodyLarge;
  final TextStyle bodyMedium;
  final TextStyle bodySmall;
  final TextStyle caption;
  final TextStyle actionLabel;
  final TextStyle badge;
  final TextStyle karaoke;
  final TextStyle karaokeActive;
  final TextStyle karaokeDim;

  final BorderRadius radiusSmall;
  final BorderRadius radiusMedium;
  final BorderRadius radiusLarge;
  final BorderRadius radiusPill;
  final BorderRadius radiusStoryCard;
  final BorderRadius radiusKidPanel;

  final List<BoxShadow> cardShadow;
  final List<BoxShadow> storyCardShadow;
  final List<BoxShadow> elevatedShadow;

  factory StorytellingTheme.light() {
    return StorytellingTheme(
      textPrimary: AppColors.textPrimary,
      textSecondary: AppColors.textSecondary,
      textMuted: AppColors.textPlaceholder,
      textDisabled: AppColors.textDisabled,
      surface: AppColors.white,
      surfaceElevated: AppColors.white,
      surfaceMuted: AppColors.kidPanelCream,
      brandPrimary: AppColors.brand500,
      brandSecondary: AppColors.blue600,
      accentYellow: AppColors.yellow500,
      accentRed: AppColors.red500,
      accentGreen: AppColors.brand600,
      accentPurple: AppColors.purple500,
      success: AppColors.success,
      error: AppColors.error,
      readingColor: AppColors.orange500,
      readingBackground: AppColors.orange100,
      playColor: AppColors.brand600,
      playBackground: AppColors.brand100,
      speakingColor: AppColors.purple500,
      speakingBackground: AppColors.purple100,
      homeBackground: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.yellow100,
          AppColors.orange100,
          AppColors.brand100,
        ],
      ),
      hubBackground: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.yellow100,
          AppColors.yellow50,
          AppColors.brand100,
        ],
      ),
      readerBackground: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.yellow100,
          AppColors.orange100,
          AppColors.yellow200,
        ],
      ),
      gameBackground: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.brand50,
          AppColors.brand100,
          AppColors.brand200,
        ],
      ),
      appTitle: AppTypography.appTitle(),
      screenTitle: AppTypography.screenTitle(),
      sectionTitle: AppTypography.sectionTitle(),
      cardTitle: AppTypography.cardTitle(),
      modeTitle: AppTypography.modeTitle(),
      storyCardTitle: AppTypography.storyCardTitle(),
      bodyLarge: AppTypography.bodyLarge(),
      bodyMedium: AppTypography.bodyMedium(),
      bodySmall: AppTypography.bodySmall(),
      caption: AppTypography.caption(),
      actionLabel: AppTypography.actionLabel(),
      badge: AppTypography.badge(color: AppColors.iconOrange),
      karaoke: AppTypography.karaoke(),
      karaokeActive: AppTypography.karaokeActive(),
      karaokeDim: AppTypography.karaokeDim(),
      radiusSmall: BorderRadius.circular(8),
      radiusMedium: BorderRadius.circular(12),
      radiusLarge: BorderRadius.circular(16),
      radiusPill: BorderRadius.circular(16),
      radiusStoryCard: BorderRadius.circular(16),
      radiusKidPanel: BorderRadius.circular(28),
      cardShadow: [
        BoxShadow(
          color: AppColors.black10,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      storyCardShadow: const [
        BoxShadow(
          color: AppColors.storyCardShadow,
          offset: Offset(0, 3),
        ),
      ],
      elevatedShadow: [
        BoxShadow(
          color: AppColors.orange600.withValues(alpha: 0.2),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  /// Golden-bordered story card (companion `StoryListCard` style).
  BoxDecoration storyCardDecoration() {
    return BoxDecoration(
      color: surface,
      borderRadius: radiusStoryCard,
      border: Border.all(color: AppColors.storyCardBorder, width: 2),
      boxShadow: storyCardShadow,
    );
  }

  /// Brown kid panel frame.
  BoxDecoration kidPanelDecoration() {
    return BoxDecoration(
      color: AppColors.kidPanelBrown,
      borderRadius: radiusKidPanel,
    );
  }

  /// Cream inner panel body.
  BoxDecoration kidPanelInnerDecoration({bool standalone = false}) {
    return BoxDecoration(
      color: AppColors.kidPanelCream,
      borderRadius: standalone
          ? BorderRadius.circular(20)
          : const BorderRadius.vertical(bottom: Radius.circular(24)),
    );
  }

  BoxDecoration surfaceCardDecoration({double alpha = 1}) {
    return BoxDecoration(
      color: surface.withValues(alpha: alpha),
      borderRadius: radiusLarge,
      border: Border.all(color: AppColors.borderDefault),
      boxShadow: cardShadow,
    );
  }

  @override
  StorytellingTheme copyWith({
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? textDisabled,
    Color? surface,
    Color? surfaceElevated,
    Color? surfaceMuted,
    Color? brandPrimary,
    Color? brandSecondary,
    Color? accentYellow,
    Color? accentRed,
    Color? accentGreen,
    Color? accentPurple,
    Color? success,
    Color? error,
    Color? readingColor,
    Color? readingBackground,
    Color? playColor,
    Color? playBackground,
    Color? speakingColor,
    Color? speakingBackground,
    LinearGradient? homeBackground,
    LinearGradient? hubBackground,
    LinearGradient? readerBackground,
    LinearGradient? gameBackground,
    TextStyle? appTitle,
    TextStyle? screenTitle,
    TextStyle? sectionTitle,
    TextStyle? cardTitle,
    TextStyle? modeTitle,
    TextStyle? storyCardTitle,
    TextStyle? bodyLarge,
    TextStyle? bodyMedium,
    TextStyle? bodySmall,
    TextStyle? caption,
    TextStyle? actionLabel,
    TextStyle? badge,
    TextStyle? karaoke,
    TextStyle? karaokeActive,
    TextStyle? karaokeDim,
    BorderRadius? radiusSmall,
    BorderRadius? radiusMedium,
    BorderRadius? radiusLarge,
    BorderRadius? radiusPill,
    BorderRadius? radiusStoryCard,
    BorderRadius? radiusKidPanel,
    List<BoxShadow>? cardShadow,
    List<BoxShadow>? storyCardShadow,
    List<BoxShadow>? elevatedShadow,
  }) {
    return StorytellingTheme(
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textMuted: textMuted ?? this.textMuted,
      textDisabled: textDisabled ?? this.textDisabled,
      surface: surface ?? this.surface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      brandPrimary: brandPrimary ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      accentYellow: accentYellow ?? this.accentYellow,
      accentRed: accentRed ?? this.accentRed,
      accentGreen: accentGreen ?? this.accentGreen,
      accentPurple: accentPurple ?? this.accentPurple,
      success: success ?? this.success,
      error: error ?? this.error,
      readingColor: readingColor ?? this.readingColor,
      readingBackground: readingBackground ?? this.readingBackground,
      playColor: playColor ?? this.playColor,
      playBackground: playBackground ?? this.playBackground,
      speakingColor: speakingColor ?? this.speakingColor,
      speakingBackground: speakingBackground ?? this.speakingBackground,
      homeBackground: homeBackground ?? this.homeBackground,
      hubBackground: hubBackground ?? this.hubBackground,
      readerBackground: readerBackground ?? this.readerBackground,
      gameBackground: gameBackground ?? this.gameBackground,
      appTitle: appTitle ?? this.appTitle,
      screenTitle: screenTitle ?? this.screenTitle,
      sectionTitle: sectionTitle ?? this.sectionTitle,
      cardTitle: cardTitle ?? this.cardTitle,
      modeTitle: modeTitle ?? this.modeTitle,
      storyCardTitle: storyCardTitle ?? this.storyCardTitle,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      caption: caption ?? this.caption,
      actionLabel: actionLabel ?? this.actionLabel,
      badge: badge ?? this.badge,
      karaoke: karaoke ?? this.karaoke,
      karaokeActive: karaokeActive ?? this.karaokeActive,
      karaokeDim: karaokeDim ?? this.karaokeDim,
      radiusSmall: radiusSmall ?? this.radiusSmall,
      radiusMedium: radiusMedium ?? this.radiusMedium,
      radiusLarge: radiusLarge ?? this.radiusLarge,
      radiusPill: radiusPill ?? this.radiusPill,
      radiusStoryCard: radiusStoryCard ?? this.radiusStoryCard,
      radiusKidPanel: radiusKidPanel ?? this.radiusKidPanel,
      cardShadow: cardShadow ?? this.cardShadow,
      storyCardShadow: storyCardShadow ?? this.storyCardShadow,
      elevatedShadow: elevatedShadow ?? this.elevatedShadow,
    );
  }

  @override
  StorytellingTheme lerp(ThemeExtension<StorytellingTheme>? other, double t) {
    if (other is! StorytellingTheme) return this;
    return t < 0.5 ? this : other;
  }
}
