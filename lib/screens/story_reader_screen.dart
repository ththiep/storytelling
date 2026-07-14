import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/story_reader/story_reader_bloc.dart';
import '../bloc/story_reader/story_reader_event.dart';
import '../bloc/story_reader/story_reader_state.dart';
import '../di/injection_container.dart';
import '../models/story.dart';
import '../widgets/karaoke_text.dart';

class StoryReaderScreen extends StatelessWidget {
  const StoryReaderScreen({super.key, required this.storyId});

  final int storyId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<StoryReaderBloc>()..add(StoryReaderStarted(storyId)),
      child: const _StoryReaderView(),
    );
  }
}

class _StoryReaderView extends StatefulWidget {
  const _StoryReaderView();

  @override
  State<_StoryReaderView> createState() => _StoryReaderViewState();
}

class _StoryReaderViewState extends State<_StoryReaderView> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF8EE), Color(0xFFF5DFC4), Color(0xFFE9C9A2)],
          ),
        ),
        child: SafeArea(
          child: BlocConsumer<StoryReaderBloc, StoryReaderState>(
            listenWhen: (previous, current) {
              if (previous is StoryReaderReady && current is StoryReaderReady) {
                return previous.pageIndex != current.pageIndex;
              }
              return false;
            },
            listener: (context, state) {
              if (state is! StoryReaderReady || !_pageController.hasClients) {
                return;
              }
              final page = _pageController.page?.round() ?? 0;
              if (page != state.pageIndex) {
                _pageController.animateToPage(
                  state.pageIndex,
                  duration: const Duration(milliseconds: 320),
                  curve: Curves.easeOutCubic,
                );
              }
            },
            builder: (context, state) {
              return switch (state) {
                StoryReaderInitial() || StoryReaderLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
                StoryReaderFailure(:final message) => Center(
                  child: Text('Lỗi: $message'),
                ),
                final StoryReaderReady ready => Column(
                  children: [
                    _ReaderHeader(
                      title: ready.story.title,
                      subtitle:
                          'Trang ${ready.pageIndex + 1}/${ready.playback.pages.length} · ${ready.story.author.split('\n').first}',
                      onClose: () {
                        context.read<StoryReaderBloc>().add(
                          const StoryReaderClosed(),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: ready.playback.pages.length,
                        onPageChanged: (index) {
                          context.read<StoryReaderBloc>().add(
                            StoryReaderPageChanged(index),
                          );
                        },
                        itemBuilder: (context, index) {
                          final page = ready.playback.pages[index];
                          final isCurrent = index == ready.pageIndex;
                          return _StoryPageView(
                            page: page,
                            activeWordIndex: isCurrent
                                ? ready.activeWordIndex
                                : -1,
                          );
                        },
                      ),
                    ),
                    _ReaderControls(state: ready),
                  ],
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _StoryPageView extends StatelessWidget {
  const _StoryPageView({required this.page, required this.activeWordIndex});

  final StoryPage page;
  final int activeWordIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 12),
          _PageImage(imageUrl: page.imageUrl),
          const SizedBox(height: 28),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: KaraokeText(
                  text: page.displayText,
                  activeWordIndex: activeWordIndex,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageImage extends StatelessWidget {
  const _PageImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    final isAsset = imageUrl.startsWith('assets/');

    Widget fallback() => const Text('📖', style: TextStyle(fontSize: 72));

    if (isAsset) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imageUrl,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => fallback(),
        ),
      );
    }

    if (!isNetwork) return fallback();

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        imageUrl,
        height: 160,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => fallback(),
      ),
    );
  }
}

class _ReaderHeader extends StatelessWidget {
  const _ReaderHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.arrow_back_rounded),
            color: const Color(0xFF2B2118),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2B2118),
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF7A6856),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReaderControls extends StatelessWidget {
  const _ReaderControls({required this.state});

  final StoryReaderReady state;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<StoryReaderBloc>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        children: [
          _PlayButton(
            isSpeaking: state.isSpeaking,
            isFinished: state.isFinished,
            onPressed: () {
              if (state.isFinished) {
                bloc.add(const StoryReaderReplayPressed());
              } else if (state.isSpeaking) {
                bloc.add(const StoryReaderPausePressed());
              } else {
                bloc.add(const StoryReaderPlayPressed());
              }
            },
          ),
          const SizedBox(height: 12),
          Text(
            state.isFinished
                ? 'Đã đọc xong câu chuyện'
                : state.isSpeaking
                ? 'Đang đọc…'
                : state.isPaused
                ? 'Đã tạm dừng'
                : 'Nhấn phát để nghe',
            style: const TextStyle(fontSize: 13, color: Color(0xFF7A6856)),
          ),
          const SizedBox(height: 10),
          _AutoTurnPageSwitch(
            enabled: state.autoTurnPage,
            onChanged: (enabled) {
              bloc.add(StoryReaderAutoTurnPageToggled(enabled));
            },
          ),
        ],
      ),
    );
  }
}

class _AutoTurnPageSwitch extends StatelessWidget {
  const _AutoTurnPageSwitch({required this.enabled, required this.onChanged});

  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.56),
      borderRadius: BorderRadius.circular(28),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 6, 10, 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              size: 18,
              color: Color(0xFF7A6856),
            ),
            const SizedBox(width: 8),
            const Text(
              'Auto chuyển trang',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF7A6856),
              ),
            ),
            const SizedBox(width: 8),
            Switch(
              value: enabled,
              onChanged: onChanged,
              activeThumbColor: const Color(0xFFC45C26),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  const _PlayButton({
    required this.isSpeaking,
    required this.isFinished,
    required this.onPressed,
  });

  final bool isSpeaking;
  final bool isFinished;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFC45C26),
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 72,
          height: 72,
          child: Icon(
            isFinished
                ? Icons.replay_rounded
                : isSpeaking
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}
