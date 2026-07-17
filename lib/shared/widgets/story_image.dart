import 'package:flutter/material.dart';

import 'package:storytelling/app/theme/app_colors.dart';
import 'package:storytelling/core/logging/app_logger.dart';

class StoryImage extends StatelessWidget {
  const StoryImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isNetwork =
        imageUrl.startsWith('http://') || imageUrl.startsWith('https://');
    final isAsset = imageUrl.startsWith('assets/');

    Widget child;
    if (isNetwork) {
      child = Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, error, stackTrace) {
          AppLogger.warning(
            'image',
            'Failed to load network image url=$imageUrl',
            error: error,
            stackTrace: stackTrace,
          );
          return _fallback(width: width, height: height);
        },
      );
    } else if (isAsset) {
      child = Image.asset(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, error, stackTrace) {
          AppLogger.warning(
            'image',
            'Failed to load asset image path=$imageUrl',
            error: error,
            stackTrace: stackTrace,
          );
          return _fallback(width: width, height: height);
        },
      );
    } else {
      AppLogger.warning('image', 'Unsupported image source=$imageUrl');
      child = _fallback(width: width, height: height);
    }

    if (borderRadius == null) return child;

    return ClipRRect(borderRadius: borderRadius!, child: child);
  }

  Widget _fallback({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      color: AppColors.imagePlaceholder,
      alignment: Alignment.center,
      child: Icon(Icons.image_rounded, color: AppColors.orange700, size: 32),
    );
  }
}
