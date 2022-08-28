import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import '../../component/di/dependencies.dart';
import '../common/utils/utils.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.isTapable = false,
    this.height,
    this.placeholderWidget,
    this.errorWidget,
  }) : super(key: key);

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

    return GestureDetector(
      onTap: isTapable
          ? () => showDialog(
                context: context,
                builder: (context) {
                  return FullImageWidget(imageUrl: imageUrl);
                },
              )
          : null,
      child: CachedNetworkImage(
        cacheKey: imageUrl,
        imageUrl: imageUrl,
        height: height,
        memCacheHeight: cacheHeight,
        placeholder: placeholderWidget ?? getIt.get<Utils>().onLoading,
        errorWidget: errorWidget ?? getIt.get<Utils>().onError,
      ),
    );
  }
}

class FullImageWidget extends StatefulWidget {
  const FullImageWidget({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  @override
  State<FullImageWidget> createState() => _FullImageWidgetState();
}

class _FullImageWidgetState extends State<FullImageWidget> {
  late PhotoViewController controller;

  @override
  void initState() {
    controller = PhotoViewController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: PhotoView(
          controller: controller,
          initialScale: PhotoViewComputedScale.contained,
          backgroundDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          onScaleEnd: (context, details, controllerValue) {
            controller.value = controller.initial;
          },
          imageProvider: CachedNetworkImageProvider(
            widget.imageUrl,
            cacheKey: widget.imageUrl,
          ),
        ),
      ),
    );
  }
}
