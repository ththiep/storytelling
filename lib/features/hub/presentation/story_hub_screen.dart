import 'package:flutter/material.dart';

import 'package:storytelling/app/theme/app_assets.dart';
import 'package:storytelling/app/theme/app_colors.dart';
import 'package:storytelling/app/theme/theme_manager.dart';
import 'package:storytelling/features/play/presentation/story_game_screen.dart';
import 'package:storytelling/features/reading/presentation/story_reader_screen.dart';
import 'package:storytelling/l10n/app_localizations.dart';
import 'package:storytelling/shared/models/story.dart';
import 'package:storytelling/shared/widgets/story_back_button.dart';
import 'package:storytelling/shared/widgets/story_image.dart';
import 'package:storytelling/shared/widgets/story_scaffold_background.dart';

class StoryHubScreen extends StatelessWidget {
  const StoryHubScreen({super.key, required this.story});

  final StoryDetail story;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: StoryScaffoldBackground(
        overlayColor: AppColors.yellow50.withValues(alpha: 0.45),
        child: SafeArea(
          child: Column(
            children: [
              _HubHeader(title: story.title),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                  child: DecoratedBox(
                    decoration: theme.kidPanelDecoration(),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: DecoratedBox(
                        decoration: theme.kidPanelInnerDecoration(
                          standalone: true,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                          child: Column(
                            children: [
                              _StorySummary(story: story),
                              const SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  l10n.hubQuestion,
                                  style: theme.screenTitle.copyWith(
                                    fontSize: 22,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              _ModeCard(
                                icon: Icons.auto_stories_rounded,
                                color: theme.readingColor,
                                backgroundColor: theme.readingBackground,
                                title: l10n.readStoryTitle,
                                subtitle: l10n.readStorySubtitle,
                                actionLabel: l10n.readStoryAction,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          StoryReaderScreen(storyId: story.id),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              _ModeCard(
                                icon: Icons.extension_rounded,
                                color: theme.playColor,
                                backgroundColor: theme.playBackground,
                                title: l10n.playTitle,
                                subtitle: l10n.playSubtitle,
                                actionLabel: l10n.playAction,
                                onTap: story.pages.isEmpty
                                    ? null
                                    : () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) => StoryGameScreen(
                                              storyTitle: story.title,
                                              pages: story.pages,
                                            ),
                                          ),
                                        );
                                      },
                              ),
                              const SizedBox(height: 12),
                              _ModeCard(
                                icon: Icons.mic_rounded,
                                color: theme.speakingColor,
                                backgroundColor: theme.speakingBackground,
                                title: l10n.speakTitle,
                                subtitle: l10n.speakSubtitle,
                                actionLabel: l10n.comingSoon,
                                onTap: null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HubHeader extends StatelessWidget {
  const _HubHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          StoryBackButton(onPressed: () => Navigator.of(context).pop()),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.sectionTitle,
            ),
          ),
        ],
      ),
    );
  }
}

class _StorySummary extends StatelessWidget {
  const _StorySummary({required this.story});

  final StoryDetail story;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: theme.storyCardDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StoryImage(
              imageUrl: story.imageUrl,
              width: 96,
              height: 130,
              borderRadius: theme.radiusMedium,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(story.title, style: theme.cardTitle),
                  const SizedBox(height: 6),
                  Text(
                    story.author,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _SummaryBadge(
                        iconAsset: AppAssets.storyTime,
                        text: l10n.minutesCount(story.durationMinutes),
                        color: theme.readingColor,
                      ),
                      _SummaryBadge(
                        iconAsset: AppAssets.storyBook,
                        text: l10n.pagesCount(story.pages.length),
                        color: theme.brandSecondary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryBadge extends StatelessWidget {
  const _SummaryBadge({
    this.icon,
    this.iconAsset,
    required this.text,
    required this.color,
  }) : assert(icon != null || iconAsset != null);

  final IconData? icon;
  final String? iconAsset;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: theme.radiusSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconAsset != null)
              Image.asset(iconAsset!, width: 15, height: 15)
            else
              Icon(icon, size: 15, color: color),
            const SizedBox(width: 4),
            Text(text, style: theme.badge.copyWith(color: color)),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final String actionLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final enabled = onTap != null;

    return Material(
      color: AppColors.white.withValues(alpha: enabled ? 1 : 0.7),
      borderRadius: theme.radiusLarge,
      child: InkWell(
        onTap: onTap,
        borderRadius: theme.radiusLarge,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: theme.radiusLarge,
            border: Border.all(
              color: enabled ? AppColors.borderDefault : AppColors.zinc200,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: theme.radiusMedium,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.modeTitle.copyWith(
                        color: enabled ? theme.textPrimary : theme.textDisabled,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: theme.bodySmall),
                    const SizedBox(height: 6),
                    Text(
                      actionLabel,
                      style: theme.actionLabel.copyWith(
                        color: enabled ? color : theme.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                enabled
                    ? Icons.arrow_forward_ios_rounded
                    : Icons.lock_clock_rounded,
                size: 18,
                color: enabled ? color : theme.textDisabled,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
