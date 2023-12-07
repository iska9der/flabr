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
  const FullImageWidget({super.key, required this.provider});

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
    return Scaffold(
      /// TODO: нижняя панель с действиями для изображений
      /// bottomNavigationBar: const BottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.close_rounded, size: 32),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(.9),
      body: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: PhotoView(
          controller: controller,
          initialScale: PhotoViewComputedScale.contained,
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
          onScaleEnd: (context, details, controllerValue) {
            /// controller.value = controller.initial;
          },
          imageProvider: widget.provider,
        ),
      ),
    );
  }
}
