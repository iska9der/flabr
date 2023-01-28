import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullAssetImageWidget extends StatelessWidget {
  const FullAssetImageWidget({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return FullImageWidget(
      provider: AssetImage(assetPath),
    );
  }
}

class FullNetworkImageWidget extends StatelessWidget {
  const FullNetworkImageWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return FullImageWidget(
      provider: CachedNetworkImageProvider(
        imageUrl,
        cacheKey: imageUrl,
      ),
    );
  }
}

class FullImageWidget extends StatefulWidget {
  const FullImageWidget({Key? key, required this.provider}) : super(key: key);

  final ImageProvider provider;

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
      child: Stack(
        children: [
          PhotoView(
            controller: controller,
            initialScale: PhotoViewComputedScale.contained,
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            onScaleEnd: (context, details, controllerValue) {
              // controller.value = controller.initial;
            },
            imageProvider: widget.provider,
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}
