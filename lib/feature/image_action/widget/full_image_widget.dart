import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';

import '../../../di/di.dart';
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
  late PhotoViewScaleStateController scaleController;
  Offset? dragStart;
  int activePointers = 0;
  int? dragPointer;
  Timer? singleTapDismissTimer;
  bool isClosing = false;

  static const _dismissSwipeDistance = 80.0;
  static const _dismissSwipeVerticalFactor = 1.5;

  @override
  void initState() {
    controller = PhotoViewController();
    scaleController = PhotoViewScaleStateController();

    super.initState();
  }

  @override
  void dispose() {
    singleTapDismissTimer?.cancel();
    controller.dispose();
    scaleController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listener не участвует в gesture arena и не мешает PhotoView обрабатывать
    // pinch-to-zoom, double tap и pan внутри увеличенного изображения.
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerMove: _handlePointerMove,
      onPointerUp: _handlePointerUp,
      onPointerCancel: _handlePointerUp,
      child: PhotoView(
        controller: controller,
        scaleStateController: scaleController,
        initialScale: PhotoViewComputedScale.contained,
        backgroundDecoration: const BoxDecoration(color: Colors.transparent),
        onTapUp: _handleTapUp,
        imageProvider: widget.provider,
      ),
    );
  }

  void _handlePointerDown(PointerDownEvent event) {
    // Второй tap отменяет отложенное закрытие, чтобы double tap успел увеличить
    // изображение через внутренний recognizer PhotoView.
    singleTapDismissTimer?.cancel();
    singleTapDismissTimer = null;

    activePointers++;

    if (activePointers == 1) {
      // Закрытие по свайпу отслеживается только для одного пальца
      dragPointer = event.pointer;
      dragStart = event.position;
      return;
    }

    // Второй палец означает жест масштабирования, dismiss-свайп больше не валиден
    dragPointer = null;
    dragStart = null;
  }

  void _handlePointerMove(PointerMoveEvent event) {
    final start = dragStart;
    if (start == null ||
        activePointers != 1 ||
        dragPointer != event.pointer ||
        isClosing ||
        scaleController.scaleState != .initial) {
      return;
    }

    final offset = event.position - start;
    final isSwipeDown = offset.dy > _dismissSwipeDistance;
    // Диагональный свайп не должен закрывать модалку при обычном pan изображения
    final isMostlyVertical =
        offset.dy.abs() > offset.dx.abs() * _dismissSwipeVerticalFactor;
    if (!isSwipeDown || !isMostlyVertical) {
      return;
    }

    isClosing = true;
    Navigator.of(context).pop();
  }

  void _handleTapUp(
    BuildContext context,
    TapUpDetails details,
    PhotoViewControllerValue controllerValue,
  ) {
    if (isClosing || activePointers > 1) {
      return;
    }

    singleTapDismissTimer?.cancel();
    singleTapDismissTimer = Timer(kDoubleTapTimeout, () {
      if (!mounted || isClosing) {
        return;
      }

      isClosing = true;
      Navigator.of(context).pop();
    });
  }

  void _handlePointerUp(PointerEvent event) {
    if (activePointers > 0) {
      activePointers--;
    }

    if (event.pointer == dragPointer || activePointers == 0) {
      _resetDrag();
    }
  }

  void _resetDrag() {
    dragPointer = null;
    dragStart = null;
    isClosing = false;
  }
}

class FullImageNetworkModal extends StatelessWidget {
  const FullImageNetworkModal({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocProvider(
        create: (_) => ImageActionCubit(
          client: getIt(instanceName: 'siteClient'),
          url: imageUrl,
        ),
        child: const FullImageBottomBar(),
      ),
      backgroundColor: Colors.transparent,
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
      child: Stack(
        children: [
          Row(
            children: [
              BlocBuilder<ImageActionCubit, ImageActionState>(
                buildWhen: (previous, current) =>
                    previous.canSave != current.canSave,
                builder: (context, state) {
                  return IconButton(
                    icon: const Icon(Icons.download),
                    tooltip: 'Скачать',
                    onPressed: switch (state.canSave) {
                      true =>
                        () => context.read<ImageActionCubit>().pickAndSave(),
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
          Align(
            alignment: Alignment.topCenter,
            child: FloatingActionButton(
              mini: true,
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close_rounded, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}
