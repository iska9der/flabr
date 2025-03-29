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
    this.loadingWidget,
    this.errorWidget,
  });

  final String imageUrl;
  final bool isTapable;
  final double? height;
  final PlaceholderWidgetBuilder? loadingWidget;
  final LoadingErrorWidgetBuilder? errorWidget;

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
              : CachedNetworkImage(
                cacheKey: imageUrl,
                imageUrl: imageUrl,
                height: height,
                memCacheHeight: cacheHeight,
                placeholder: loadingWidget ?? (_, _) => const _ImageSkeleton(),
                errorWidget: errorWidget ?? (_, _, _) => const _ImageError(),
              ),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  // ignore: unused_element_parameter
  const _ImageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppDimensions.imageHeight,
      child: Skeletonizer(child: ColoredBox(color: Colors.white)),
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
