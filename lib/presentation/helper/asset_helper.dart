import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../core/component/logger/logger.dart';
import '../constants/constants.dart';

abstract class AssetHelper {
  static void loadLicense() => LicenseRegistry.addLicense(() async* {
    final geologica = await rootBundle.loadString(LicenseAssets.fontGeologica);
    yield LicenseEntryWithLineBreaks(['flabr'], geologica);
  });

  static Future<void> preloadAssets(List<ImageProvider> providers) async {
    logger.info('Предзагрузка изображений...');

    await Future.wait([
      for (final provider in providers) _preloadAsset(provider),
    ]);
  }

  static Future<void> _preloadAsset(ImageProvider provider) {
    final pixelRatio =
        WidgetsBinding
            .instance
            .platformDispatcher
            .implicitView
            ?.devicePixelRatio ??
        1.0;
    final ImageConfiguration config = ImageConfiguration(
      bundle: rootBundle,
      devicePixelRatio: pixelRatio,
      platform: defaultTargetPlatform,
    );
    final Completer<void> completer = Completer<void>();
    final ImageStream stream = provider.resolve(config);

    late final ImageStreamListener listener;

    listener = ImageStreamListener(
      (ImageInfo image, bool sync) {
        logger.info('Картинка ${image.debugLabel} предзагружена');
        completer.complete();
        stream.removeListener(listener);
      },
      onError: (Object exception, StackTrace? stackTrace) {
        completer.complete();
        stream.removeListener(listener);
        logger.error(
          exception,
          stackTrace,
        );
      },
    );

    stream.addListener(listener);
    return completer.future;
  }
}
