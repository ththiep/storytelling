import 'package:flutter/material.dart';

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
    final base =
        style ??
        Theme.of(context).textTheme.headlineSmall?.copyWith(
          height: 1.55,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF2B2118),
        ) ??
        const TextStyle();
    final active =
        activeStyle ??
        base.copyWith(
          color: const Color(0xFFC45C26),
          backgroundColor: const Color(0xFFFFE0B8),
        );
    final dim = dimStyle ?? base.copyWith(color: const Color(0xFF8A7A6B));
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
