import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../component/di/dependencies.dart';
import '../../../../component/http/http_client.dart';
import '../cubit/image_download_cubit.dart';

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
    return Scaffold(
      bottomNavigationBar: BlocProvider(
        create: (_) => ImageDownloadCubit(
          client: getIt.get<HttpClient>(instanceName: 'siteClient'),
          url: imageUrl,
        ),
        child: const FullImageBottomAppBar(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.close_rounded, size: 32),
        onPressed: () => Navigator.of(context).pop(),
      ),
      backgroundColor: Colors.transparent,
      body: FullImageWidget(
        provider: CachedNetworkImageProvider(
          imageUrl,
          cacheKey: imageUrl,
        ),
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
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: PhotoView(
        controller: controller,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(.9),
        ),
        onScaleEnd: (context, details, controllerValue) {
          /// controller.value = controller.initial;
        },
        imageProvider: widget.provider,
      ),
    );
  }
}

class FullImageBottomAppBar extends StatelessWidget {
  const FullImageBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          BlocBuilder<ImageDownloadCubit, ImageDownloadState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.download),
                tooltip: 'Скачать',
                onPressed: switch (state.status) {
                  ImageDownloadStatus.notSupported ||
                  ImageDownloadStatus.loading =>
                    null,
                  _ => () => context.read<ImageDownloadCubit>().pickAndSave(),
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
