import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/story_list/story_list_bloc.dart';
import '../bloc/story_list/story_list_event.dart';
import '../bloc/story_list/story_list_state.dart';
import '../models/story.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/theme_manager.dart';
import '../widgets/story_image.dart';
import '../widgets/story_scaffold_background.dart';
import '../widgets/stroke_text.dart';
import 'story_hub_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return Scaffold(
      body: StoryScaffoldBackground(
        overlayColor: AppColors.yellow50.withValues(alpha: 0.55),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              final bloc = context.read<StoryListBloc>()
                ..add(const StoryListRefreshed());
              await bloc.stream.firstWhere(
                (state) =>
                    state is StoryListLoaded || state is StoryListFailure,
              );
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: AppColors.yellow300,
                              child: Icon(
                                Icons.auto_stories_rounded,
                                color: theme.readingColor,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StrokeText(
                                text: 'Góc kể chuyện',
                                strokeColor: AppColors.strokeTitle,
                                strokeWidth: 4,
                                shadowOffset: const Offset(0, 3),
                                shadowColor: AppColors.strokeTitleShadow,
                                textStyle: theme.appTitle.copyWith(
                                  color: AppColors.white,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DecoratedBox(
                          decoration: theme.kidPanelInnerDecoration(
                            standalone: true,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Text(
                              'Chọn truyện, nghe giọng đọc và đọc chữ sáng lên.',
                              style: theme.bodyMedium.copyWith(
                                color: AppColors.textOrange,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<StoryListBloc, StoryListState>(
                  builder: (context, state) {
                    return switch (state) {
                      StoryListInitial() ||
                      StoryListLoading() => const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      StoryListFailure(:final message) => SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text('Lỗi tải chuyện: $message')),
                      ),
                      StoryListLoaded(:final stories) => SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                        sliver: SliverList.separated(
                          itemCount: stories.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final story = stories[index];
                            return _StoryCard(
                              story: story,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => StoryHubScreen(story: story),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    };
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryCard extends StatelessWidget {
  const _StoryCard({required this.story, required this.onTap});

  final StoryDetail story;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;

    return Material(
      color: AppColors.transparent,
      child: InkWell(
        borderRadius: theme.radiusStoryCard,
        onTap: onTap,
        child: Ink(
          decoration: theme.storyCardDecoration(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      StoryImage(
                        imageUrl: story.imageUrl,
                        width: 82,
                        height: 82,
                        borderRadius: theme.radiusMedium,
                      ),
                      Image.asset(
                        AppAssets.playButton,
                        width: 40,
                        height: 40,
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          story.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.storyCardTitle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          story.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.bodySmall,
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _StoryBadge(
                              icon: Icons.star_rounded,
                              label: 'Cấp ${story.level}',
                              color: theme.brandPrimary,
                            ),
                            _StoryBadge(
                              iconAsset: AppAssets.storyTime,
                              label: '${story.durationMinutes} phút',
                              color: theme.readingColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (story.isFavorite)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.asset(
                        AppAssets.heartIconActive,
                        width: 28,
                        height: 28,
                      ),
                    ),
                  Image.asset(
                    AppAssets.rightChevron,
                    width: 20,
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StoryBadge extends StatelessWidget {
  const _StoryBadge({
    this.icon,
    this.iconAsset,
    required this.label,
    required this.color,
  }) : assert(icon != null || iconAsset != null);

  final IconData? icon;
  final String? iconAsset;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
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
            Text(label, style: AppTypography.badge(color: color)),
          ],
        ),
      ),
    );
  }
}
