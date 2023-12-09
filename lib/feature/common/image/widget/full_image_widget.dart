import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../component/di/dependencies.dart';
import '../../../../component/http/http_client.dart';
import '../cubit/image_action_cubit.dart';

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

class FullNetworkImageModalWidget extends StatelessWidget {
  const FullNetworkImageModalWidget({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocProvider(
        create: (_) => ImageActionCubit(
          client: getIt.get<HttpClient>(instanceName: 'siteClient'),
          url: imageUrl,
        ),
        child: const FullImageBottomAppBar(),
      ),
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => Navigator.of(context).pop(),
        child: const Icon(Icons.close_rounded, size: 32),
      ),
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
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
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
          BlocBuilder<ImageActionCubit, ImageActionState>(
            buildWhen: (previous, current) =>
                previous.canSave != current.canSave,
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.download),
                tooltip: 'Скачать',
                onPressed: switch (state.canSave) {
                  true => () => context.read<ImageActionCubit>().pickAndSave(),
                  false => null,
                },
              );
            },
          ),
          BlocBuilder<ImageActionCubit, ImageActionState>(
            buildWhen: (previous, current) =>
                previous.canShare != current.canShare,
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Поделиться',
                onPressed: switch (state.canShare) {
                  true => () => context.read<ImageActionCubit>().share(),
                  false => null,
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
