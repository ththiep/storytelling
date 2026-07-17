import 'package:flutter/material.dart';

import 'package:storytelling/app/theme/app_assets.dart';

class StoryScaffoldBackground extends StatelessWidget {
  const StoryScaffoldBackground({
    super.key,
    required this.child,
    this.overlayColor,
  });

  final Widget child;
  final Color? overlayColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppAssets.storyBackground,
          fit: BoxFit.cover,
        ),
        if (overlayColor != null)
          DecoratedBox(
            decoration: BoxDecoration(color: overlayColor),
            child: child,
          )
        else
          child,
      ],
    );
  }
}
