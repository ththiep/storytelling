import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/story_reader/story_reader_bloc.dart';
import '../bloc/story_reader/story_reader_event.dart';
import '../bloc/story_reader/story_reader_state.dart';
import '../di/injection_container.dart';
import '../widgets/karaoke_text.dart';
import 'story_completion_screen.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF7D8), Color(0xFFFFE4BB), Color(0xFFFFCFA2)],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<StoryReaderBloc, StoryReaderState>(
            buildWhen: (previous, current) {
              if (previous is StoryReaderReady && current is StoryReaderReady) {
                return previous.pageIndex != current.pageIndex ||
                    previous.status != current.status ||
                    previous.autoTurnPage != current.autoTurnPage ||
                    previous.playback.pages.length !=
                        current.playback.pages.length;
              }
              return previous.runtimeType != current.runtimeType;
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
                          'Trang ${ready.pageIndex + 1}/${ready.playback.pages.length}',
                      onClose: () {
                        context.read<StoryReaderBloc>().add(
                          const StoryReaderClosed(),
                        );
                        Navigator.of(context).pop();
                      },
                    ),
                    const Expanded(
                      child: RepaintBoundary(child: _KaraokeReader()),
                    ),
                    _ReaderControls(state: ready),
                  ],
                ),
                final StoryReaderCompleted completed =>
                  StoryCompletionView(state: completed),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _KaraokeReader extends StatelessWidget {
  const _KaraokeReader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoryReaderBloc, StoryReaderState>(
      buildWhen: (previous, current) {
        if (previous is! StoryReaderReady || current is! StoryReaderReady) {
          return previous.runtimeType != current.runtimeType;
        }
        return previous.pageIndex != current.pageIndex ||
            previous.activeWordIndex != current.activeWordIndex;
      },
      builder: (context, state) {
        if (state is! StoryReaderReady) return const SizedBox.shrink();
        final page = state.currentPage;
        if (page == null) return const SizedBox.shrink();

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragEnd: (details) {
            final velocity = details.primaryVelocity ?? 0;
            if (velocity < -200 &&
                state.pageIndex < state.playback.pages.length - 1) {
              context.read<StoryReaderBloc>().add(
                StoryReaderPageChanged(state.pageIndex + 1),
              );
            } else if (velocity > 200 && state.pageIndex > 0) {
              context.read<StoryReaderBloc>().add(
                StoryReaderPageChanged(state.pageIndex - 1),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8A4B20).withValues(alpha: 0.12),
                    blurRadius: 22,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 20, 18, 20),
                child: Center(
                  child: SingleChildScrollView(
                    child: KaraokeText(
                      text: page.displayText,
                      activeWordIndex: state.activeWordIndex,
                      style: const TextStyle(
                        fontSize: 30,
                        height: 1.42,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3B2A1C),
                      ),
                      activeStyle: const TextStyle(
                        fontSize: 30,
                        height: 1.42,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8F2D1B),
                        backgroundColor: Color(0xFFFFD86B),
                      ),
                      dimStyle: const TextStyle(
                        fontSize: 30,
                        height: 1.42,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF8A6F55),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.white.withValues(alpha: 0.86)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 6, 14, 6),
          child: Row(
            children: [
              IconButton.filledTonal(
                onPressed: onClose,
                icon: const Icon(Icons.arrow_back_rounded),
                color: const Color(0xFF3B2A1C),
                style: IconButton.styleFrom(
                  backgroundColor: const Color(0xFFFFE3A6),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2B2118),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A6856),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.auto_stories_rounded,
                color: Color(0xFFC45C26),
                size: 24,
              ),
            ],
          ),
        ),
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
    final status = state.isFinished
        ? 'Con đã nghe xong rồi!'
        : state.isSpeaking
        ? 'Đang kể chuyện...'
        : state.isPaused
        ? 'Tạm dừng một chút'
        : 'Chạm nút để nghe tiếp';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: Colors.white.withValues(alpha: 0.9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8A4B20).withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Row(
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
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      status,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF3B2A1C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _AutoTurnPageSwitch(
                      enabled: state.autoTurnPage,
                      onChanged: (enabled) {
                        bloc.add(StoryReaderAutoTurnPageToggled(enabled));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      color: const Color(0xFFFFEBC2),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 4, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_stories_rounded,
              size: 16,
              color: Color(0xFFC45C26),
            ),
            const SizedBox(width: 6),
            const Text(
              'Tự lật trang',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Color(0xFF6E4B2E),
              ),
            ),
            const SizedBox(width: 6),
            Switch(
              value: enabled,
              onChanged: onChanged,
              activeThumbColor: const Color(0xFFC45C26),
              activeTrackColor: const Color(0xFFFFC36B),
              inactiveThumbColor: const Color(0xFFBFA489),
              inactiveTrackColor: const Color(0xFFFFF6E6),
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
      color: const Color(0xFFD94B2B),
      shape: const CircleBorder(),
      elevation: 6,
      shadowColor: const Color(0xFFD94B2B).withValues(alpha: 0.35),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 68,
          height: 68,
          child: Icon(
            isFinished
                ? Icons.replay_rounded
                : isSpeaking
                ? Icons.pause_rounded
                : Icons.play_arrow_rounded,
            color: Colors.white,
            size: 38,
          ),
        ),
      ),
    );
  }
}
