import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/story_reader/story_reader_bloc.dart';
import '../bloc/story_reader/story_reader_event.dart';
import '../bloc/story_reader/story_reader_state.dart';
import 'story_game_screen.dart';

class StoryCompletionView extends StatelessWidget {
  const StoryCompletionView({super.key, required this.state});

  final StoryReaderCompleted state;

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              children: [
                const Spacer(),
                const Icon(
                  Icons.celebration_rounded,
                  size: 72,
                  color: Color(0xFFC45C26),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Chúc mừng!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2B2118),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Con đã nghe xong câu chuyện\n"${state.story.title}"',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6E5A48),
                  ),
                ),
                const Spacer(),
                _CompletionOptionCard(
                  icon: Icons.replay_rounded,
                  iconColor: const Color(0xFF8F2D1B),
                  iconBackground: const Color(0xFFFFD86B),
                  title: 'Bạn có muốn nghe lại không?',
                  subtitle: 'Nghe lại từ đầu',
                  onTap: () {
                    bloc.add(const StoryReaderListenAgainPressed());
                  },
                ),
                const SizedBox(height: 14),
                _CompletionOptionCard(
                  icon: Icons.videogame_asset_rounded,
                  iconColor: const Color(0xFF1F5C4A),
                  iconBackground: const Color(0xFFB8E8D8),
                  title: 'Bạn có muốn chơi game không?',
                  subtitle: 'Chơi game cùng câu chuyện',
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => StoryGameScreen(
                          storyId: state.story.id,
                          storyTitle: state.story.title,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
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
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF2B2118),
                  ),
                ),
              ),
              const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF2E8B57),
                size: 26,
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
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.78),
      borderRadius: BorderRadius.circular(24),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 18, 16, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.92)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8A4B20).withValues(alpha: 0.1),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: iconColor, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF2B2118),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7A6856),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Color(0xFFC45C26),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
