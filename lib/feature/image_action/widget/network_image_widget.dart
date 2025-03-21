import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/component/di/di.dart';
import '../../../presentation/utils/utils.dart';
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
                placeholder: loadingWidget ?? getIt<Utils>().onImageLoading,
                errorWidget: errorWidget ?? getIt<Utils>().onImageError,
              ),
    );
  }
}
