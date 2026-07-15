import 'package:flutter/material.dart';

class StoryGameScreen extends StatelessWidget {
  const StoryGameScreen({
    super.key,
    required this.storyId,
    required this.storyTitle,
  });

  final int storyId;
  final String storyTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F8F2), Color(0xFFB8E8D8), Color(0xFF8FD4BE)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: const Color(0xFF1F5C4A),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFD4F5E8),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        storyTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1F3D34),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.videogame_asset_rounded,
                  size: 80,
                  color: Color(0xFF1F5C4A),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Game sắp ra mắt!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F3D34),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Phần chơi game cho câu chuyện #$storyId\nđang được phát triển.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A6B60),
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Quay lại'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF1F5C4A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
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
