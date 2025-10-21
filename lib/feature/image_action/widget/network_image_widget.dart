import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../presentation/extension/context.dart';
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
    int? cacheHeight = height != null
        ? (height! * MediaQuery.devicePixelRatioOf(context)).round()
        : null;

    final barrierColor = context.theme.colorScheme.surface.withValues(
      alpha: .9,
    );

    return GestureDetector(
      onTap: switch (isTapable) {
        true => () => showDialog(
          context: context,
          barrierColor: barrierColor,
          builder: (_) => FullImageNetworkModal(imageUrl: imageUrl),
        ),
        false => null,
      },
      child: switch (imageUrl.contains('.svg')) {
        true => SvgPicture.network(imageUrl, height: height),
        false => SizedBox(
          height: height,
          child: Image(
            height: height,
            errorBuilder: errorBuilder ?? (_, _, _) => const _ImageError(),
            frameBuilder: (_, child, frame, wasSyncLoaded) {
              final isLoading = frame == null && !wasSyncLoaded;
              if (!isLoading) return child;

              if (loadingPlaceholder != null) return loadingPlaceholder!;

              return SizedBox(
                height: height,
                width: double.infinity,
                child: Skeletonizer(
                  enabled: isLoading,
                  child: ColoredBox(
                    color: context.theme.colorScheme.surfaceContainer,
                  ),
                ),
              );
            },
            image: ResizeImage.resizeIfNeeded(
              null,
              cacheHeight,
              CachedNetworkImageProvider(imageUrl, cacheKey: imageUrl),
            ),
          ),
        ),
      },
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
