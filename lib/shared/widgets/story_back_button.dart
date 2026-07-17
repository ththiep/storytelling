import 'package:flutter/material.dart';

import 'package:storytelling/app/theme/app_assets.dart';

class StoryBackButton extends StatelessWidget {
  const StoryBackButton({
    super.key,
    required this.onPressed,
    this.size = 48,
  });

  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        AppAssets.backButton,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
