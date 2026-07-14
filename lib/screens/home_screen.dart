import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/story_list/story_list_bloc.dart';
import '../bloc/story_list/story_list_event.dart';
import '../bloc/story_list/story_list_state.dart';
import '../models/story.dart';
import 'story_reader_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFF7D8), Color(0xFFFFE0B5), Color(0xFFD9F0F1)],
          ),
        ),
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
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 28, 24, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 26,
                              backgroundColor: Color(0xFFFFD86B),
                              child: Icon(
                                Icons.auto_stories_rounded,
                                color: Color(0xFF8F2D1B),
                                size: 30,
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Góc kể chuyện',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF2B2118),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(
                              'Chọn truyện, nghe giọng đọc và đọc chữ sáng lên.',
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.35,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF5C4A3D),
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
                                    builder: (_) =>
                                        StoryReaderScreen(storyId: story.id),
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
    return Material(
      color: Colors.white.withValues(alpha: 0.84),
      borderRadius: BorderRadius.circular(8),
      elevation: 2,
      shadowColor: const Color(0xFF8A4B20).withValues(alpha: 0.16),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              _CoverThumb(imageUrl: story.imageUrl),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      story.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2B2118),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A6856),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _StoryBadge(
                          icon: Icons.star_rounded,
                          label: 'Cấp ${story.level}',
                          color: const Color(0xFF197C7B),
                        ),
                        _StoryBadge(
                          icon: Icons.timer_rounded,
                          label: '${story.durationMinutes} phút',
                          color: const Color(0xFFC45C26),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (story.isFavorite)
                const Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(
                    Icons.favorite_rounded,
                    color: Color(0xFFD94B2B),
                    size: 22,
                  ),
                ),
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFD86B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Color(0xFF8F2D1B),
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryBadge extends StatelessWidget {
  const _StoryBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
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
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverThumb extends StatelessWidget {
  const _CoverThumb({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    final isAsset = imageUrl.startsWith('assets/');

    Widget child;
    if (isNetwork) {
      child = Image.network(
        imageUrl,
        width: 82,
        height: 82,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.menu_book_rounded, color: Color(0xFFB07A45)),
      );
    } else if (isAsset) {
      child = Image.asset(
        imageUrl,
        width: 82,
        height: 82,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.menu_book_rounded, color: Color(0xFFB07A45)),
      );
    } else {
      child = const Icon(
        Icons.menu_book_rounded,
        color: Color(0xFFB07A45),
        size: 32,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 82,
        height: 82,
        color: const Color(0xFFFFE8B8),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
