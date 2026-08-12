import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

/// Загружает HTML-ресурсы в хранилища, выбранные вызывающим сервисом
abstract interface class HtmlAssetDownloader {
  /// Загружает файл в application documents и возвращает его file URI
  Future<Uri?> downloadToApplicationDocuments({
    required String url,
    required String directory,
    required String filename,
  });

  /// Создаёт дочерний каталог у внешнего document provider
  Future<Uri> createDirectory(Uri parent, String name);

  /// Загружает файл в каталог внешнего document provider
  Future<Uri?> downloadToUri({
    required String url,
    required Uri directory,
    required String filename,
  });
}

/// Реализация загрузчика на основе background_downloader
@LazySingleton(as: HtmlAssetDownloader)
class BackgroundHtmlAssetDownloader implements HtmlAssetDownloader {
  BackgroundHtmlAssetDownloader() : _downloader = FileDownloader();

  @visibleForTesting
  BackgroundHtmlAssetDownloader.forTest(FileDownloader downloader)
    : _downloader = downloader;

  final FileDownloader _downloader;

  @override
  Future<Uri?> downloadToApplicationDocuments({
    required String url,
    required String directory,
    required String filename,
  }) async {
    final task = DownloadTask(
      url: url,
      filename: filename,
      directory: directory,
      retries: 2,
    );
    final file = File(await task.filePath());
    if (await file.exists()) return file.uri;

    final result = await _downloader.download(task);
    return result.status == TaskStatus.complete ? file.uri : null;
  }

  @override
  Future<Uri> createDirectory(Uri parent, String name) =>
      _downloader.uri.createDirectory(parent, name);

  @override
  Future<Uri?> downloadToUri({
    required String url,
    required Uri directory,
    required String filename,
  }) async {
    final task = UriDownloadTask(
      url: url,
      filename: filename,
      directoryUri: directory,
      retries: 2,
    );
    final result = await _downloader.download(task);
    return result.status == TaskStatus.complete
        ? directory.replace(
            pathSegments: [...directory.pathSegments, filename],
          )
        : null;
  }
}
