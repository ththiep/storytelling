import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:storytelling/app/theme/app_assets.dart';
import 'package:storytelling/app/theme/app_colors.dart';
import 'package:storytelling/app/theme/app_typography.dart';
import 'package:storytelling/app/theme/theme_manager.dart';
import 'package:storytelling/l10n/app_localizations.dart';
import 'package:storytelling/shared/models/story.dart';
import 'package:storytelling/shared/widgets/story_back_button.dart';
import 'package:storytelling/shared/widgets/story_image.dart';
import 'package:storytelling/shared/widgets/story_scaffold_background.dart';
import 'package:storytelling/shared/widgets/stroke_text.dart';

class StoryTalkScreen extends StatefulWidget {
  const StoryTalkScreen({super.key, required this.story});

  final StoryDetail story;

  @override
  State<StoryTalkScreen> createState() => _StoryTalkScreenState();
}

class _StoryTalkScreenState extends State<StoryTalkScreen> {
  int _pageIndex = 0;
  bool _isListening = false;
  final Set<int> _practicedPageIndexes = <int>{};

  List<StoryPage> get _pages {
    final pages = [...widget.story.pages]
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
    return pages;
  }

  bool get _isComplete =>
      _pages.isNotEmpty && _practicedPageIndexes.length == _pages.length;

  void _togglePractice() {
    setState(() {
      if (_isListening) {
        _isListening = false;
        _practicedPageIndexes.add(_pageIndex);
      } else {
        _isListening = true;
      }
    });
  }

  void _goToPage(int nextIndex) {
    if (nextIndex < 0 || nextIndex >= _pages.length) return;
    setState(() {
      _pageIndex = nextIndex;
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);
    final pages = _pages;

    return Scaffold(
      body: StoryScaffoldBackground(
        overlayColor: AppColors.purple100.withValues(alpha: 0.35),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _TalkHeader(
                    title: widget.story.title,
                    subtitle: pages.isEmpty
                        ? l10n.speakTitle
                        : l10n.talkPageCount(_pageIndex + 1, pages.length),
                  ),
                  Expanded(
                    child: pages.isEmpty
                        ? Center(
                            child: Text(
                              l10n.talkEmpty,
                              textAlign: TextAlign.center,
                              style: theme.bodyMedium.copyWith(
                                color: theme.textSecondary,
                              ),
                            ),
                          )
                        : _TalkPracticePage(
                            page: pages[_pageIndex],
                            isListening: _isListening,
                            isPracticed: _practicedPageIndexes.contains(
                              _pageIndex,
                            ),
                          ),
                  ),
                  if (pages.isNotEmpty)
                    _TalkControls(
                      isListening: _isListening,
                      canGoPrevious: _pageIndex > 0,
                      canGoNext: _pageIndex < pages.length - 1,
                      onPrevious: () => _goToPage(_pageIndex - 1),
                      onNext: () => _goToPage(_pageIndex + 1),
                      onTogglePractice: _togglePractice,
                    ),
                ],
              ),
              if (_isComplete) const _TalkCelebrationOverlay(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TalkHeader extends StatelessWidget {
  const _TalkHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

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
              StoryBackButton(onPressed: () => Navigator.of(context).pop()),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.sectionTitle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodySmall,
                    ),
                  ],
                ),
              ),
              Icon(Icons.mic_rounded, color: theme.speakingColor, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _TalkPracticePage extends StatelessWidget {
  const _TalkPracticePage({
    required this.page,
    required this.isListening,
    required this.isPracticed,
  });

  final StoryPage page;
  final bool isListening;
  final bool isPracticed;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);
    final status = isListening
        ? l10n.talkListeningStatus
        : isPracticed
        ? l10n.talkDoneStatus
        : l10n.talkReadyStatus;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
      child: DecoratedBox(
        decoration: theme.storyCardDecoration(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageHeight = math.min(
                250.0,
                math.max(120.0, constraints.maxHeight * 0.38),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: imageHeight,
                    child: StoryImage(
                      imageUrl: page.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      borderRadius: theme.radiusMedium,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    status,
                    textAlign: TextAlign.center,
                    style: theme.bodyMedium.copyWith(
                      color: isListening
                          ? theme.speakingColor
                          : theme.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.yellow50.withValues(alpha: 0.75),
                        borderRadius: theme.radiusMedium,
                        border: Border.all(color: AppColors.borderDefault),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(18),
                        child: Text(
                          page.displayText,
                          textAlign: TextAlign.center,
                          style: theme.karaoke.copyWith(
                            color: theme.textPrimary,
                            fontSize: 30,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TalkControls extends StatelessWidget {
  const _TalkControls({
    required this.isListening,
    required this.canGoPrevious,
    required this.canGoNext,
    required this.onPrevious,
    required this.onNext,
    required this.onTogglePractice,
  });

  final bool isListening;
  final bool canGoPrevious;
  final bool canGoNext;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onTogglePractice;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: DecoratedBox(
        decoration: theme.surfaceCardDecoration(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _PageControlButton(
                    icon: Icons.chevron_left_rounded,
                    label: l10n.talkPrevious,
                    onPressed: canGoPrevious ? onPrevious : null,
                  ),
                ),
              ),
              _TalkMicButton(
                isListening: isListening,
                onPressed: onTogglePractice,
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: _PageControlButton(
                    icon: Icons.chevron_right_rounded,
                    label: l10n.talkNext,
                    onPressed: canGoNext ? onNext : null,
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

class _TalkMicButton extends StatelessWidget {
  const _TalkMicButton({required this.isListening, required this.onPressed});

  final bool isListening;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: isListening ? theme.speakingColor : AppColors.brandSecondary,
          shape: const CircleBorder(),
          elevation: 8,
          shadowColor: AppColors.black10,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: 82,
              height: 82,
              child: Icon(
                isListening ? Icons.check_rounded : Icons.mic_rounded,
                color: AppColors.white,
                size: 42,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isListening ? l10n.talkStop : l10n.talkStart,
          style: theme.caption.copyWith(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class _PageControlButton extends StatelessWidget {
  const _PageControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return Material(
      color: AppColors.transparent,
      borderRadius: theme.radiusMedium,
      child: InkWell(
        borderRadius: theme.radiusMedium,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: onPressed == null
                    ? theme.textSecondary.withValues(alpha: 0.35)
                    : theme.speakingColor,
                size: 30,
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.caption.copyWith(
                  color: onPressed == null
                      ? theme.textSecondary.withValues(alpha: 0.35)
                      : theme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TalkCelebrationOverlay extends StatelessWidget {
  const _TalkCelebrationOverlay();

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final l10n = AppLocalizations.of(context);

    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.speakingColor.withValues(alpha: 0.12),
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
                      text: l10n.talkCompleteTitle,
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
                      l10n.talkCompleteMessage,
                      textAlign: TextAlign.center,
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
