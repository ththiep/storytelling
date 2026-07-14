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
        );
    final active =
        activeStyle ??
        base?.copyWith(
          color: const Color(0xFFC45C26),
          fontWeight: FontWeight.w800,
          backgroundColor: const Color(0xFFFFE0B8),
        );
    final dim = dimStyle ?? base?.copyWith(color: const Color(0xFF8A7A6B));

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
              ? active
              : isPast
              ? base
              : dim,
        ),
      );
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(children: spans),
    );
  }
}
