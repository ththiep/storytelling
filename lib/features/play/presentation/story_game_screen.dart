import 'package:flutter/material.dart';

import 'package:storytelling/app/theme/app_assets.dart';
import 'package:storytelling/app/theme/app_colors.dart';
import 'package:storytelling/app/theme/app_typography.dart';
import 'package:storytelling/app/theme/theme_manager.dart';
import 'package:storytelling/features/play/presentation/widgets/page_order_puzzle_game.dart';
import 'package:storytelling/shared/models/story.dart';
import 'package:storytelling/shared/widgets/story_back_button.dart';
import 'package:storytelling/shared/widgets/story_scaffold_background.dart';
import 'package:storytelling/shared/widgets/stroke_text.dart';

class StoryGameScreen extends StatefulWidget {
  const StoryGameScreen({
    super.key,
    required this.storyTitle,
    required this.pages,
  });

  final String storyTitle;
  final List<StoryPage> pages;

  @override
  State<StoryGameScreen> createState() => _StoryGameScreenState();
}

class _StoryGameScreenState extends State<StoryGameScreen> {
  bool _showCelebration = false;

  void _onPuzzleCompleted() {
    if (_showCelebration) return;
    setState(() => _showCelebration = true);
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _showCelebration = false);
    });
  }

  List<PagePuzzlePiece> get _pieces {
    final sortedPages = [...widget.pages]
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));

    return sortedPages
        .asMap()
        .entries
        .map(
          (entry) => PagePuzzlePiece(
            pageIndex: entry.key,
            imageUrl: entry.value.imageUrl,
          ),
        )
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return Scaffold(
      body: StoryScaffoldBackground(
        overlayColor: AppColors.yellow50.withValues(alpha: 0.35),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                    child: Row(
                      children: [
                        StoryBackButton(
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.storyTitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.sectionTitle,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Ghép hình theo thứ tự trang',
                                style: theme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.extension_rounded,
                          color: theme.playColor,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageOrderPuzzleGame(
                      pieces: _pieces,
                      onCompleted: _onPuzzleCompleted,
                    ),
                  ),
                ],
              ),
              if (_showCelebration) const _PuzzleCelebrationOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PuzzleCelebrationOverlay extends StatelessWidget {
  const _PuzzleCelebrationOverlay();

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.playColor.withValues(alpha: 0.12),
          ),
          child: Center(
            child: DecoratedBox(
              decoration: theme.storyCardDecoration(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 22,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      AppAssets.congratulation,
                      width: 96,
                      height: 96,
                    ),
                    const SizedBox(height: 12),
                    StrokeText(
                      text: 'Hoàn thành!',
                      strokeColor: AppColors.strokeTitle,
                      strokeWidth: 3,
                      shadowOffset: const Offset(0, 2),
                      shadowColor: AppColors.strokeTitleShadow,
                      textStyle: AppTypography.sectionTitle(
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Con đã ghép đúng hình rồi!',
                      style: theme.bodyMedium.copyWith(
                        color: theme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
