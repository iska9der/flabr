import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../core/component/di/di.dart';
import '../cubit/image_action_cubit.dart';

class FullImageAsset extends StatelessWidget {
  const FullImageAsset({super.key, required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return FullImageProvider(provider: AssetImage(assetPath));
  }
}

class FullImageProvider extends StatefulWidget {
  const FullImageProvider({super.key, required this.provider});

  final ImageProvider provider;

  @override
  State<FullImageProvider> createState() => _FullImageProviderState();
}

class _FullImageProviderState extends State<FullImageProvider> {
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

class FullImageNetworkModal extends StatelessWidget {
  const FullImageNetworkModal({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocProvider(
        create:
            (_) => ImageActionCubit(
              client: getIt(instanceName: 'siteClient'),
              url: imageUrl,
            ),
        child: const FullImageBottomBar(),
      ),
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => Navigator.of(context).pop(),
        child: const Icon(Icons.close_rounded, size: 32),
      ),
      body: FullImageProvider(
        provider: CachedNetworkImageProvider(imageUrl, cacheKey: imageUrl),
      ),
    );
  }
}

class FullImageBottomBar extends StatelessWidget {
  const FullImageBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: [
          BlocBuilder<ImageActionCubit, ImageActionState>(
            buildWhen:
                (previous, current) => previous.canSave != current.canSave,
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
            buildWhen:
                (previous, current) => previous.canShare != current.canShare,
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
