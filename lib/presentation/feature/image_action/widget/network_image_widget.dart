part of '../part.dart';

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
                builder: (_) => FullImageNetworkModal(imageUrl: imageUrl),
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
              placeholder: loadingWidget ?? getIt<Utils>().onImageLoading,
              errorWidget: errorWidget ?? getIt<Utils>().onImageError,
            ),
    );
  }
}
