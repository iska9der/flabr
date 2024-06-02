import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/utils/utils.dart';
import '../../../../component/di/injector.dart';
import 'full_image_widget.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.isTapable = false,
    this.height,
    this.placeholderWidget,
    this.errorWidget,
  });

  final String imageUrl;
  final bool isTapable;
  final double? height;
  final PlaceholderWidgetBuilder? placeholderWidget;
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    int? cacheHeight = height != null
        ? (height! * MediaQuery.of(context).devicePixelRatio).round()
        : null;
    final barrierColor = Theme.of(context).colorScheme.surface.withOpacity(.9);

    return GestureDetector(
      onTap: isTapable
          ? () => showDialog(
                context: context,
                useRootNavigator: false,
                barrierColor: barrierColor,
                builder: (_) => FullNetworkImageModalWidget(imageUrl: imageUrl),
              )
          : null,
      child: imageUrl.contains('.svg')
          ? SvgPicture.network(
              imageUrl,
              height: height,
            )
          : CachedNetworkImage(
              cacheKey: imageUrl,
              imageUrl: imageUrl,
              height: height,
              memCacheHeight: cacheHeight,
              placeholder: placeholderWidget ?? getIt<Utils>().onImageLoading,
              errorWidget: errorWidget ?? getIt<Utils>().onImageError,
            ),
    );
  }
}
