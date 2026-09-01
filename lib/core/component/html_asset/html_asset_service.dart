import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'html_asset_downloader.dart';

/// Определяет поведение при ошибке загрузки отдельного HTML-ресурса
enum HtmlAssetFailureStrategy {
  /// Прерывает обработку HTML и передаёт ошибку вызывающему коду
  abort,

  /// Сохраняет исходный сетевой URL недоступного ресурса
  keepRemote,

  /// Удаляет недоступное изображение или ссылку на другой ресурс
  removeResource,
}

/// Сохраняет ресурсы из HTML по указанному вызывающим кодом пути
@lazySingleton
class HtmlAssetService {
  HtmlAssetService(this._downloader)
    : _documentsDirectory = getApplicationDocumentsDirectory;

  @visibleForTesting
  HtmlAssetService.forTest(
    this._downloader, {
    required Future<Directory> Function() documentsDirectory,
  }) : _documentsDirectory = documentsDirectory;

  final HtmlAssetDownloader _downloader;
  final Future<Directory> Function() _documentsDirectory;

  /// Схема ссылок на ассеты внутри application documents
  static const String cacheScheme = 'flabr-asset';

  static final RegExp _resourcePattern = RegExp(
    r'''(?<prefix>\b(?:src|poster)\s*=\s*["'])(?<url>https?://[^"']+)(?<suffix>["'])''',
    caseSensitive: false,
  );
  static final RegExp _sourceSetPattern = RegExp(
    r'''\s+(?:data-)?srcset\s*=\s*(?:"[^"]*"|'[^']*')''',
    caseSensitive: false,
  );
  static final RegExp _imageTagPattern = RegExp(
    r'''<(?:img|source)\b[^>]*>''',
    caseSensitive: false,
  );

  /// Загружает сетевые ресурсы и заменяет ссылки согласно выбранной цели
  ///
  /// Один URL загружается только один раз, даже если встречается в HTML повторно
  Future<String> saveHtml({
    required String html,
    required HtmlAssetTarget target,
    HtmlAssetFailureStrategy failureStrategy =
        HtmlAssetFailureStrategy.keepRemote,
  }) async {
    if (kIsWeb || !_resourcePattern.hasMatch(html)) {
      return html;
    }

    final pathSegments = _safePathSegments(target.path);
    if (pathSegments.isEmpty) {
      throw ArgumentError.value(target.path, 'target.path');
    }

    final directory = p.posix.joinAll(pathSegments);
    final uriDirectory = switch (target) {
      _ApplicationDocumentsHtmlAssetTarget() => null,
      _EmbeddedHtmlAssetTarget() => null,
      _UriHtmlAssetTarget(:final parent) => await _createUriDirectory(
        parent,
        pathSegments,
      ),
    };

    return _replaceResources(html, failureStrategy, (url, filename) async {
      switch (target) {
        case _ApplicationDocumentsHtmlAssetTarget():
          final uri = await _downloader.downloadToApplicationDocuments(
            url: url,
            directory: directory,
            filename: filename,
          );
          if (uri == null) return null;
          return Uri(
            scheme: cacheScheme,
            path: '/${p.posix.joinAll([...pathSegments, filename])}',
          ).toString();
        case _EmbeddedHtmlAssetTarget():
          return await _downloadEmbedded(
            url: url,
            directory: directory,
            filename: filename,
          );
        case _UriHtmlAssetTarget():
          final uri = await _downloader.downloadToUri(
            url: url,
            directory: uriDirectory!,
            filename: filename,
          );
          if (uri == null) return null;
          return p.posix.join(directory, filename);
      }
    });
  }

  /// Преобразует внутренний cache URI в путь внутри application documents
  Future<Uri?> resolveUri(String source) async {
    final uri = Uri.tryParse(source);
    if (uri == null || uri.scheme != cacheScheme || uri.pathSegments.isEmpty) {
      return null;
    }

    final documents = await _documentsDirectory();
    return Uri.file(
      p.joinAll([
        documents.path,
        ...uri.pathSegments.map(_safeSegment),
      ]),
    );
  }

  /// Удаляет каталог ассетов, расположенный внутри application documents
  ///
  /// URI-цели принадлежат внешнему document provider и здесь не удаляются
  Future<void> delete(HtmlAssetTarget target) async {
    if (kIsWeb) return;
    if (target is _UriHtmlAssetTarget) {
      throw UnsupportedError('Only application documents can be deleted');
    }

    final pathSegments = _safePathSegments(target.path);
    if (pathSegments.isEmpty) {
      throw ArgumentError.value(target.path, 'target.path');
    }

    final documents = await _documentsDirectory();
    final directory = Directory(
      p.joinAll([documents.path, ...pathSegments]),
    );
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  Future<Uri> _createUriDirectory(
    Uri parent,
    List<String> pathSegments,
  ) async {
    var directory = parent;
    for (final segment in pathSegments) {
      directory = await _downloader.createDirectory(directory, segment);
    }
    return directory;
  }

  Future<String> _replaceResources(
    String html,
    HtmlAssetFailureStrategy failureStrategy,
    Future<String?> Function(String url, String filename) download,
  ) async {
    final urls = _resourcePattern
        .allMatches(html)
        .map((match) => match.namedGroup('url'))
        .whereType<String>()
        .toSet();

    final entries = await Future.wait(
      urls.map((url) async {
        final filename = _filenameFor(url);
        try {
          final replacement = await download(url, filename);
          if (replacement == null && failureStrategy == .abort) {
            throw StateError('Не удалось загрузить ресурс: $url');
          }
          return MapEntry(url, replacement);
        } catch (_) {
          if (failureStrategy == .abort) rethrow;
          return MapEntry<String, String?>(url, null);
        }
      }),
    );

    final replacements = Map<String, String>.fromEntries(
      entries
          .where((entry) => entry.value != null)
          .map((entry) => MapEntry(entry.key, entry.value!)),
    );

    final failedUrls = entries
        .where((entry) => entry.value == null)
        .map((entry) => entry.key)
        .toSet();

    String htmlResolved = html;
    if (failureStrategy == .removeResource) {
      htmlResolved = htmlResolved.replaceAllMapped(
        _imageTagPattern,
        (match) {
          final tag = match.group(0)!;
          final anyFailedUrl = _resourcePattern
              .allMatches(tag)
              .any((res) => failedUrls.contains(res.namedGroup('url')));
          if (anyFailedUrl) return '';
          return tag;
        },
      );
    }

    final htmlWithLocalResources = htmlResolved.replaceAllMapped(
      _resourcePattern,
      (match) {
        final regexpMatch = match as RegExpMatch;
        final url = regexpMatch.namedGroup('url')!;
        if (failureStrategy == .removeResource && failedUrls.contains(url)) {
          return '';
        }
        return '${regexpMatch.namedGroup('prefix')}${replacements[url] ?? url}'
            '${regexpMatch.namedGroup('suffix')}';
      },
    );

    return htmlWithLocalResources.replaceAll(_sourceSetPattern, '');
  }

  Future<String?> _downloadEmbedded({
    required String url,
    required String directory,
    required String filename,
  }) async {
    final uri = await _downloader.downloadToApplicationDocuments(
      url: url,
      directory: directory,
      filename: filename,
    );
    if (uri == null) return null;

    final bytes = await File.fromUri(uri).readAsBytes();
    final mimeType = _mimeType(filename, bytes);
    return 'data:$mimeType;base64,${base64Encode(bytes)}';
  }

  String _mimeType(String filename, Uint8List bytes) {
    final extension = p.extension(filename).toLowerCase();
    final extensionMimeType = switch (extension) {
      '.png' => 'image/png',
      '.jpg' || '.jpeg' => 'image/jpeg',
      '.webp' => 'image/webp',
      '.gif' => 'image/gif',
      '.svg' => 'image/svg+xml',
      _ => null,
    };
    if (extensionMimeType != null) return extensionMimeType;

    if (_startsWith(bytes, const [0x89, 0x50, 0x4e, 0x47])) {
      return 'image/png';
    }
    if (_startsWith(bytes, const [0xff, 0xd8, 0xff])) {
      return 'image/jpeg';
    }
    if (_startsWith(bytes, const [0x47, 0x49, 0x46, 0x38])) {
      return 'image/gif';
    }
    if (_startsWith(bytes, const [0x52, 0x49, 0x46, 0x46]) &&
        bytes.length >= 12 &&
        _startsWith(bytes.sublist(8), const [0x57, 0x45, 0x42, 0x50])) {
      return 'image/webp';
    }
    return 'application/octet-stream';
  }

  bool _startsWith(Uint8List bytes, List<int> signature) {
    if (bytes.length < signature.length) return false;
    for (var index = 0; index < signature.length; index++) {
      if (bytes[index] != signature[index]) return false;
    }
    return true;
  }

  String _filenameFor(String url) {
    final digest = sha256.convert(utf8.encode(url)).toString();
    final extension = p.extension(Uri.parse(url).path).toLowerCase();
    final safeExtension = RegExp(r'^\.[a-z0-9]{1,8}$').hasMatch(extension)
        ? extension
        : '';
    return '$digest$safeExtension';
  }

  String _safeSegment(String value) {
    final segment = value.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    if (segment.isEmpty || segment == '.' || segment == '..') {
      return '_';
    }
    return segment;
  }

  List<String> _safePathSegments(String path) => path
      .replaceAll('\\', '/')
      .split('/')
      .where((segment) => segment.isNotEmpty)
      .map(_safeSegment)
      .toList(growable: false);
}

/// Описывает место хранения и способ представления ссылок на HTML-ресурсы
sealed class HtmlAssetTarget {
  const HtmlAssetTarget._(this.path);

  /// Хранит файлы в application documents и возвращает cache URI приложения
  const factory HtmlAssetTarget.applicationDocuments({required String path}) =
      _ApplicationDocumentsHtmlAssetTarget;

  /// Встраивает содержимое файлов в HTML как data URI
  ///
  /// Загруженные файлы остаются во временном каталоге до явного вызова
  /// [HtmlAssetService.delete]
  const factory HtmlAssetTarget.embedded({required String path}) =
      _EmbeddedHtmlAssetTarget;

  /// Хранит файлы у внешнего document provider и возвращает относительные пути
  ///
  /// Такие пути предназначены для экспорта набора связанных файлов, но не
  /// гарантируют доступ браузера к ассетам при открытии одного HTML через SAF
  const factory HtmlAssetTarget.uri({
    required Uri parent,
    required String path,
  }) = _UriHtmlAssetTarget;

  /// Относительный каталог, выбранный вызывающим кодом
  final String path;
}

final class _ApplicationDocumentsHtmlAssetTarget extends HtmlAssetTarget {
  const _ApplicationDocumentsHtmlAssetTarget({required String path})
    : super._(path);
}

final class _EmbeddedHtmlAssetTarget extends HtmlAssetTarget {
  const _EmbeddedHtmlAssetTarget({required String path}) : super._(path);
}

final class _UriHtmlAssetTarget extends HtmlAssetTarget {
  const _UriHtmlAssetTarget({required this.parent, required String path})
    : super._(path);

  final Uri parent;
}
