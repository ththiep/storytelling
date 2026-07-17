import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/story_reader/story_reader_bloc.dart';
import '../bloc/story_reader/story_reader_event.dart';
import '../bloc/story_reader/story_reader_state.dart';
import '../di/injection_container.dart';
import '../theme/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/theme_manager.dart';
import '../widgets/karaoke_text.dart';
import '../widgets/story_back_button.dart';
import '../widgets/story_image.dart';
import '../widgets/story_scaffold_background.dart';
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
    final theme = context.storyTheme;

    return Scaffold(
      body: StoryScaffoldBackground(
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
                  child: Text(
                    'Lỗi: $message',
                    style: theme.bodyMedium.copyWith(color: theme.error),
                  ),
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
        final theme = context.storyTheme;

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
              decoration: theme.storyCardDecoration(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 3,
                        child: StoryImage(
                          imageUrl: page.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          borderRadius: theme.radiusMedium,
                        ),
                      ),
                      const SizedBox(height: 16),
                      KaraokeText(
                        text: page.displayText,
                        activeWordIndex: state.activeWordIndex,
                        style: theme.karaoke,
                        activeStyle: theme.karaokeActive,
                        dimStyle: theme.karaokeDim,
                      ),
                    ],
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
              Image.asset(
                AppAssets.storyBook,
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

class _ReaderControls extends StatelessWidget {
  const _ReaderControls({required this.state});

  final StoryReaderReady state;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
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
        decoration: theme.surfaceCardDecoration(),
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
                      style: theme.bodyMedium.copyWith(
                        color: theme.textPrimary,
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
    final theme = context.storyTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.yellow100,
        borderRadius: theme.radiusMedium,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 4, 8, 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_stories_rounded,
              size: 16,
              color: theme.readingColor,
            ),
            const SizedBox(width: 6),
            Text('Tự lật trang', style: theme.caption),
            const SizedBox(width: 6),
            Switch(
              value: enabled,
              onChanged: onChanged,
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
      color: AppColors.transparent,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Image.asset(
          isFinished
              ? AppAssets.playButton
              : isSpeaking
              ? AppAssets.pauseButton
              : AppAssets.playButton,
          width: 68,
          height: 68,
        ),
      ),
    );
  }
}
