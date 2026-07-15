import 'package:flutter/material.dart';

/// Renders text with a colored stroke outline and optional drop shadow.
class StrokeText extends StatelessWidget {
  const StrokeText({
    super.key,
    required this.text,
    this.strokeColor = Colors.amber,
    this.strokeWidth = 3,
    this.textStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.overflow,
    this.maxLines,
    this.shadowOffset,
    this.shadowBlur = 0,
    this.shadowColor,
    this.shrinkWrap = false,
  });

  final String text;
  final Color strokeColor;
  final double strokeWidth;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextScaler? textScaler;
  final TextOverflow? overflow;
  final int? maxLines;
  final Offset? shadowOffset;
  final double shadowBlur;
  final Color? shadowColor;
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const defaultTextStyle = TextStyle(fontSize: 24, color: Colors.black);
        final merged = defaultTextStyle.merge(textStyle);
        final hasBoundedWidth = constraints.maxWidth.isFinite;
        final layoutMaxWidth = shrinkWrap
            ? double.infinity
            : (hasBoundedWidth ? constraints.maxWidth : double.infinity);

        final measurePainter = TextPainter(
          text: TextSpan(text: text, style: merged),
          textAlign: textAlign ?? TextAlign.start,
          textDirection: textDirection ?? TextDirection.ltr,
          textScaler: textScaler ?? TextScaler.noScaling,
          maxLines: maxLines,
        )..layout(maxWidth: layoutMaxWidth);

        final shadowPad = shadowOffset != null
            ? shadowOffset!.dy.abs() +
                  shadowOffset!.dx.abs() +
                  shadowBlur +
                  strokeWidth * 2
            : strokeWidth;

        final width = shrinkWrap || !hasBoundedWidth
            ? measurePainter.width + strokeWidth * 2
            : constraints.maxWidth;

        return CustomPaint(
          size: Size(width, measurePainter.height + shadowPad),
          painter: _StrokeTextPainter(
            text: text,
            strokeColor: strokeColor,
            strokeWidth: strokeWidth,
            textStyle: textStyle,
            textAlign: textAlign,
            textDirection: textDirection,
            textScaler: textScaler,
            overflow: overflow,
            maxLines: maxLines,
            shadowOffset: shadowOffset,
            shadowBlur: shadowBlur,
            shadowColor: shadowColor,
          ),
        );
      },
    );
  }
}

class _StrokeTextPainter extends CustomPainter {
  _StrokeTextPainter({
    required this.text,
    required this.strokeColor,
    required this.strokeWidth,
    this.textStyle,
    this.textAlign,
    this.textDirection,
    this.textScaler,
    this.overflow,
    this.maxLines,
    this.shadowOffset,
    this.shadowBlur = 0,
    this.shadowColor,
  });

  final String text;
  final Color strokeColor;
  final double strokeWidth;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextScaler? textScaler;
  final TextOverflow? overflow;
  final int? maxLines;
  final Offset? shadowOffset;
  final double shadowBlur;
  final Color? shadowColor;

  @override
  void paint(Canvas canvas, Size size) {
    const defaultTextStyle = TextStyle(fontSize: 24, color: Colors.black);
    final merged = defaultTextStyle.merge(textStyle);
    final resolvedShadowColor =
        shadowColor ?? Colors.black.withValues(alpha: 0.3);
    final shadowFilter = shadowBlur > 0
        ? MaskFilter.blur(BlurStyle.normal, shadowBlur)
        : null;

    final shadowStrokeStyle = merged.copyWith(
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = resolvedShadowColor
        ..maskFilter = shadowFilter,
    );

    final shadowFillStyle = merged.copyWith(
      foreground: Paint()
        ..color = resolvedShadowColor
        ..maskFilter = shadowFilter,
    );

    final strokeStyle = merged.copyWith(
      foreground: Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = strokeColor,
    );

    final fillStyle = merged.copyWith(color: merged.color ?? Colors.black);

    final align = textAlign ?? TextAlign.start;
    final dir = textDirection ?? TextDirection.ltr;
    final scaler = textScaler ?? TextScaler.noScaling;

    TextPainter layoutPainter(TextSpan span) => TextPainter(
      text: span,
      textAlign: align,
      textDirection: dir,
      textScaler: scaler,
      maxLines: maxLines,
    )..layout(maxWidth: size.width);

    final shadowStrokePainter = layoutPainter(
      TextSpan(text: text, style: shadowStrokeStyle),
    );
    final shadowFillPainter = layoutPainter(
      TextSpan(text: text, style: shadowFillStyle),
    );
    final strokePainter = layoutPainter(
      TextSpan(text: text, style: strokeStyle),
    );
    final fillPainter = layoutPainter(TextSpan(text: text, style: fillStyle));

    final offset = _offset(fillPainter, size);

    if (shadowOffset != null) {
      final shadowPos = offset + shadowOffset!;
      shadowStrokePainter.paint(canvas, shadowPos);
      shadowFillPainter.paint(canvas, shadowPos);
    }
    strokePainter.paint(canvas, offset);
    fillPainter.paint(canvas, offset);
  }

  Offset _offset(TextPainter painter, Size size) {
    final dy = (size.height - painter.height) / 2;
    return switch (painter.textAlign) {
      TextAlign.center => Offset((size.width - painter.width) / 2, dy),
      TextAlign.end || TextAlign.right => Offset(
        size.width - painter.width,
        dy,
      ),
      _ => Offset(0, dy),
    };
  }

  @override
  bool shouldRepaint(covariant _StrokeTextPainter old) =>
      text != old.text ||
      strokeColor != old.strokeColor ||
      strokeWidth != old.strokeWidth ||
      textStyle != old.textStyle ||
      shadowOffset != old.shadowOffset ||
      shadowBlur != old.shadowBlur ||
      shadowColor != old.shadowColor;
}
