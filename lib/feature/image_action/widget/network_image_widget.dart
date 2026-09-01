import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/component/html_asset/html_asset.dart';
import '../../../di/di.dart';
import '../../../presentation/extension/context.dart';
import '../../../presentation/theme/theme.dart';
import 'full_image_widget.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.isTapable = false,
    this.height,
    this.loadingPlaceholder,
    this.errorBuilder,
  });

  final String imageUrl;
  final bool isTapable;
  final double? height;
  final Widget? loadingPlaceholder;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final uri = Uri.tryParse(imageUrl);

    int? cacheHeight = height != null
        ? (height! * MediaQuery.devicePixelRatioOf(context)).round()
        : null;

    final barrierColor = theme.colorScheme.surface.withValues(alpha: .9);

    bool canOpenInModal = isTapable && !imageUrl.contains('.svg');

    final errorBuilderResolved =
        errorBuilder ?? (_, _, _) => _ImageError(height: height);

    if (uri?.scheme == HtmlAssetService.cacheScheme) {
      return _CachedAssetImage(
        source: imageUrl,
        height: height,
        cacheHeight: cacheHeight,
        errorBuilder: errorBuilderResolved,
      );
    }

    return GestureDetector(
      onTap: switch (canOpenInModal) {
        true => () => showDialog(
          context: context,
          barrierColor: barrierColor,
          builder: (_) => FullImageNetworkModal(imageUrl: imageUrl),
        ),
        false => null,
      },
      child: switch (imageUrl.contains('.svg')) {
        true => SvgPicture.network(
          imageUrl,
          height: height,
          errorBuilder: errorBuilderResolved,
        ),
        false => SizedBox(
          height: height,
          child: Image(
            height: height,
            errorBuilder: errorBuilderResolved,
            frameBuilder: (_, child, frame, wasSyncLoaded) {
              final isLoading = frame == null && !wasSyncLoaded;
              if (!isLoading) {
                return child;
              }

              if (loadingPlaceholder != null) {
                return loadingPlaceholder!;
              }

              return SizedBox(
                height: height,
                width: double.infinity,
                child: Skeletonizer(
                  enabled: isLoading,
                  child: ColoredBox(
                    color: theme.colorScheme.surfaceContainer,
                  ),
                ),
              );
            },
            image: ResizeImage.resizeIfNeeded(
              null,
              cacheHeight,
              CachedNetworkImageProvider(imageUrl, cacheKey: imageUrl),
            ),
          ),
        ),
      },
    );
  }
}

class _CachedAssetImage extends StatelessWidget {
  const _CachedAssetImage({
    required this.source,
    required this.height,
    required this.cacheHeight,
    required this.errorBuilder,
  });

  final String source;
  final double? height;
  final int? cacheHeight;
  final ImageErrorWidgetBuilder errorBuilder;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uri?>(
      future: getIt<HtmlAssetService>().resolveUri(source),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return errorBuilder(
            context,
            snapshot.error!,
            snapshot.stackTrace,
          );
        }
        final uri = snapshot.data;
        if (uri == null) return SizedBox(height: height);
        final file = File.fromUri(uri);

        if (uri.path.toLowerCase().endsWith('.svg')) {
          return SvgPicture.file(
            file,
            height: height,
            errorBuilder: errorBuilder,
          );
        }

        return SizedBox(
          height: height,
          child: Image(
            height: height,
            errorBuilder: errorBuilder,
            image: ResizeImage.resizeIfNeeded(
              null,
              cacheHeight,
              FileImage(file),
            ),
          ),
        );
      },
    );
  }
}

class _ImageError extends StatelessWidget {
  // ignore: unused_element_parameter
  const _ImageError({super.key, double? height})
    : height = height ?? AppDimensions.imageHeight;

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.red),
    );
  }
}
