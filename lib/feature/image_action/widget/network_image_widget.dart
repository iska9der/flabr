import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../presentation/theme/theme.dart';
import 'full_image_widget.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.isTapable = false,
    this.height,
    this.loadingPlaceholder,
    this.errorBuilder,
  });

  final String imageUrl;
  final bool isTapable;
  final double? height;
  final Widget? loadingPlaceholder;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    int? cacheHeight =
        height != null
            ? (height! * MediaQuery.of(context).devicePixelRatio).round()
            : null;

    final barrierColor = Theme.of(
      context,
    ).colorScheme.surface.withValues(alpha: .9);

    return GestureDetector(
      onTap:
          isTapable
              ? () => showDialog(
                context: context,
                barrierColor: barrierColor,
                builder: (_) => FullImageNetworkModal(imageUrl: imageUrl),
              )
              : null,
      child:
          imageUrl.contains('.svg')
              ? SvgPicture.network(imageUrl, height: height)
              : SizedBox(
                height: height,
                child: Image(
                  height: height,
                  errorBuilder:
                      errorBuilder ?? (_, _, _) => const _ImageError(),
                  frameBuilder: (
                    context,
                    child,
                    frame,
                    wasSynchronouslyLoaded,
                  ) {
                    final isLoading = frame == null && !wasSynchronouslyLoaded;
                    if (!isLoading) {
                      return child;
                    }

                    if (loadingPlaceholder != null) {
                      return loadingPlaceholder!;
                    }

                    return Skeletonizer(
                      enabled: isLoading,
                      child: const ColoredBox(color: Colors.white),
                    );
                  },
                  image: ResizeImage.resizeIfNeeded(
                    null,
                    cacheHeight,
                    CachedNetworkImageProvider(imageUrl, cacheKey: imageUrl),
                  ),
                ),
              ),
    );
  }
}

class _ImageError extends StatelessWidget {
  // ignore: unused_element_parameter
  const _ImageError({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppDimensions.imageHeight,
      child: Icon(Icons.image_not_supported_outlined, color: Colors.red),
    );
  }
}
