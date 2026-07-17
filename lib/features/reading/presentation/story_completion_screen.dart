import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:storytelling/app/theme/app_assets.dart';
import 'package:storytelling/app/theme/app_colors.dart';
import 'package:storytelling/app/theme/app_typography.dart';
import 'package:storytelling/app/theme/theme_manager.dart';
import 'package:storytelling/features/play/presentation/story_game_screen.dart';
import 'package:storytelling/features/reading/application/story_reader_bloc.dart';
import 'package:storytelling/features/reading/application/story_reader_event.dart';
import 'package:storytelling/features/reading/application/story_reader_state.dart';
import 'package:storytelling/shared/widgets/story_back_button.dart';
import 'package:storytelling/shared/widgets/story_image.dart';
import 'package:storytelling/shared/widgets/stroke_text.dart';

class StoryCompletionView extends StatelessWidget {
  const StoryCompletionView({super.key, required this.state});

  final StoryReaderCompleted state;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final bloc = context.read<StoryReaderBloc>();

    return Column(
      children: [
        _CompletionHeader(
          title: state.story.title,
          onClose: () {
            bloc.add(const StoryReaderClosed());
            Navigator.of(context).pop();
          },
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: DecoratedBox(
              decoration: theme.kidPanelDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: DecoratedBox(
                  decoration: theme.kidPanelInnerDecoration(standalone: true),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: Column(
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: 180,
                          height: 210,
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              StoryImage(
                                imageUrl: state.story.imageUrl,
                                width: 180,
                                height: 210,
                                borderRadius: theme.radiusMedium,
                              ),
                              Positioned(
                                top: -20,
                                child: Image.asset(
                                  AppAssets.congratulation,
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        StrokeText(
                          text: 'Chúc mừng!',
                          textAlign: TextAlign.center,
                          strokeColor: AppColors.strokeTitle,
                          strokeWidth: 4,
                          shadowOffset: const Offset(0, 3),
                          shadowColor: AppColors.strokeTitleShadow,
                          textStyle: AppTypography.celebrationTitle(
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Con đã nghe xong câu chuyện\n"${state.story.title}"',
                          textAlign: TextAlign.center,
                          style: theme.bodyLarge,
                        ),
                        const Spacer(),
                        _CompletionOptionCard(
                          iconAsset: AppAssets.playButton,
                          iconColor: theme.readingColor,
                          iconBackground: theme.readingBackground,
                          title: 'Bạn có muốn nghe lại không?',
                          subtitle: 'Nghe lại từ đầu',
                          onTap: () {
                            bloc.add(const StoryReaderListenAgainPressed());
                          },
                        ),
                        const SizedBox(height: 12),
                        _CompletionOptionCard(
                          iconAsset: AppAssets.storyBook,
                          iconColor: theme.playColor,
                          iconBackground: theme.playBackground,
                          title: 'Bạn có muốn chơi game không?',
                          subtitle: 'Chơi game cùng câu chuyện',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => StoryGameScreen(
                                  storyTitle: state.story.title,
                                  pages: state.story.pages,
                                ),
                              ),
                            );
                          },
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
    );
  }
}

class _CompletionHeader extends StatelessWidget {
  const _CompletionHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      child: DecoratedBox(
        decoration: theme.surfaceCardDecoration(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 14, 6),
          child: Row(
            children: [
              StoryBackButton(onPressed: onClose),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.sectionTitle,
                ),
              ),
              Image.asset(
                AppAssets.completeStory,
                width: 28,
                height: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletionOptionCard extends StatelessWidget {
  const _CompletionOptionCard({
    this.icon,
    this.iconAsset,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : assert(icon != null || iconAsset != null);

  final IconData? icon;
  final String? iconAsset;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return Material(
      color: AppColors.white,
      borderRadius: theme.radiusLarge,
      child: InkWell(
        borderRadius: theme.radiusLarge,
        onTap: onTap,
        child: Ink(
          decoration: theme.storyCardDecoration(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 16),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: theme.radiusMedium,
                  ),
                  child: iconAsset != null
                      ? Image.asset(iconAsset!, width: 32, height: 32)
                      : Icon(icon, color: iconColor, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.modeTitle),
                      const SizedBox(height: 4),
                      Text(subtitle, style: theme.bodySmall),
                    ],
                  ),
                ),
                Image.asset(
                  AppAssets.rightChevron,
                  width: 18,
                  height: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
