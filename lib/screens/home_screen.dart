import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/story_list/story_list_bloc.dart';
import '../bloc/story_list/story_list_event.dart';
import '../bloc/story_list/story_list_state.dart';
import '../models/story.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<StoryListBloc>()
                      ..add(const StoryListRefreshed());
                    await bloc.stream.firstWhere(
                      (state) =>
                          state is StoryListLoaded ||
                          state is StoryListFailure,
                    );
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      BlocBuilder<StoryListBloc, StoryListState>(
                        builder: (context, state) {
                          return switch (state) {
                            StoryListInitial() ||
                            StoryListLoading() => const SliverFillRemaining(
                              hasScrollBody: false,
                              child: Center(child: CircularProgressIndicator()),
                            ),
                            StoryListFailure(:final message) =>
                              SliverFillRemaining(
                                hasScrollBody: false,
                                child: Center(
                                  child: Text('Lỗi tải chuyện: $message'),
                                ),
                              ),
                            StoryListLoaded(:final stories) => SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 16,
                                      crossAxisSpacing: 14,
                                      childAspectRatio: 0.68,
                                    ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final story = stories[index];
                                    return _StoryGridCard(
                                      story: story,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                StoryHubScreen(story: story),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  childCount: stories.length,
                                ),
                              ),
                            ),
                          };
                        },
                      ),
                    ],
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

class _StoryGridCard extends StatelessWidget {
  const _StoryGridCard({required this.story, required this.onTap});

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: theme.radiusMedium,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(
                          color: AppColors.imagePlaceholder,
                          child: StoryImage(
                            imageUrl: story.imageUrl,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        if (story.isFavorite)
                          Positioned(
                            right: 6,
                            bottom: 6,
                            child: Image.asset(
                              AppAssets.heartIconActive,
                              width: 28,
                              height: 28,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  story.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.storyCardTitle.copyWith(
                    fontSize: 15,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
