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
            colors: [
              Color(0xFFFFF6E8),
              Color(0xFFF3E2C8),
              Color(0xFFE8D2B0),
            ],
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
                        Text(
                          'Kể chuyện',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2B2118),
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Chọn một câu chuyện, lắng nghe và theo dõi chữ karaoke.',
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.4,
                            color: Color(0xFF6F5E4D),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<StoryListBloc, StoryListState>(
                  builder: (context, state) {
                    return switch (state) {
                      StoryListInitial() || StoryListLoading() =>
                        const SliverFillRemaining(
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
                                      builder: (_) => StoryReaderScreen(
                                        storyId: story.id,
                                      ),
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
      color: Colors.white.withValues(alpha: 0.72),
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
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
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2B2118),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      story.author,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7A6856),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Level ${story.level} · ${story.durationMinutes} min',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFB07A45),
                      ),
                    ),
                  ],
                ),
              ),
              if (story.isFavorite)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.favorite, color: Color(0xFFC45C26), size: 18),
                ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB07A45),
              ),
            ],
          ),
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
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(
          Icons.menu_book_rounded,
          color: Color(0xFFB07A45),
        ),
      );
    } else if (isAsset) {
      child = Image.asset(
        imageUrl,
        width: 72,
        height: 72,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(
          Icons.menu_book_rounded,
          color: Color(0xFFB07A45),
        ),
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
        width: 72,
        height: 72,
        color: const Color(0xFFFFE8C8),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
