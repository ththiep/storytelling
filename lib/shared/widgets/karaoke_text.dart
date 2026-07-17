import 'package:flutter/material.dart';

import 'package:storytelling/app/theme/theme_manager.dart';

class KaraokeText extends StatelessWidget {
  const KaraokeText({
    super.key,
    required this.text,
    required this.activeWordIndex,
    this.style,
    this.activeStyle,
    this.dimStyle,
  });

  final String text;
  final int activeWordIndex;
  final TextStyle? style;
  final TextStyle? activeStyle;
  final TextStyle? dimStyle;

  @override
  Widget build(BuildContext context) {
    final theme = context.storyTheme;
    final base = style ?? theme.karaoke;
    final active = activeStyle ?? theme.karaokeActive;
    final dim = dimStyle ?? theme.karaokeDim;
    final activePaint = _paintOnly(base, active);
    final dimPaint = _paintOnly(base, dim);
    final spans = <InlineSpan>[];
    var wordIndex = -1;

    for (final match in RegExp(r'\S+|\s+').allMatches(text)) {
      final token = match.group(0)!;
      if (token.trim().isEmpty) {
        spans.add(TextSpan(text: token, style: base));
        continue;
      }

      wordIndex += 1;
      final isActive = wordIndex == activeWordIndex;
      final isPast = activeWordIndex >= 0 && wordIndex < activeWordIndex;

      spans.add(
        TextSpan(
          text: token,
          style: isActive
              ? activePaint
              : isPast
              ? base
              : dimPaint,
        ),
      );
    }

    return Text.rich(
      TextSpan(children: spans),
      textAlign: TextAlign.center,
      textWidthBasis: TextWidthBasis.parent,
    );
  }

  TextStyle _paintOnly(TextStyle stable, TextStyle target) {
    return stable.copyWith(
      color: target.color,
      backgroundColor: target.backgroundColor,
      decorationColor: target.decorationColor,
    );
  }
}
