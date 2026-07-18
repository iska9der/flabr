import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'html_asset_downloader.dart';

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

  static const String cacheScheme = 'flabr-asset';

  static final RegExp _resourcePattern = RegExp(
    r'''(?<prefix>\b(?:src|poster)\s*=\s*["'])(?<url>https?://[^"']+)(?<suffix>["'])''',
    caseSensitive: false,
  );

  Future<String> saveHtml({
    required String html,
    required HtmlAssetTarget target,
  }) async {
    if (kIsWeb || !_resourcePattern.hasMatch(html)) return html;

    final pathSegments = _safePathSegments(target.path);
    if (pathSegments.isEmpty) {
      throw ArgumentError.value(target.path, 'target.path');
    }

    final directory = p.posix.joinAll(pathSegments);
    final uriDirectory = switch (target) {
      _ApplicationDocumentsHtmlAssetTarget() => null,
      _UriHtmlAssetTarget(:final parent) => await _createUriDirectory(
        parent,
        pathSegments,
      ),
    };

    return _replaceResources(html, (url, filename) async {
      return switch (target) {
        _ApplicationDocumentsHtmlAssetTarget() =>
          await _downloader.downloadToApplicationDocuments(
                    url: url,
                    directory: directory,
                    filename: filename,
                  ) ==
                  null
              ? null
              : Uri(
                  scheme: cacheScheme,
                  path: '/${p.posix.joinAll([...pathSegments, filename])}',
                ).toString(),
        _UriHtmlAssetTarget() =>
          await _downloader.downloadToUri(
                    url: url,
                    directory: uriDirectory!,
                    filename: filename,
                  ) ==
                  null
              ? null
              : p.posix.join(directory, filename),
      };
    });
  }

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

  Future<void> delete(HtmlAssetTarget target) async {
    if (kIsWeb) return;
    if (target is! _ApplicationDocumentsHtmlAssetTarget) {
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
          return MapEntry(url, await download(url, filename));
        } catch (_) {
          return MapEntry<String, String?>(url, null);
        }
      }),
    );
    final replacements = Map<String, String>.fromEntries(
      entries
          .where((entry) => entry.value != null)
          .map((entry) => MapEntry(entry.key, entry.value!)),
    );

    return html.replaceAllMapped(_resourcePattern, (match) {
      final regexpMatch = match as RegExpMatch;
      final url = regexpMatch.namedGroup('url')!;
      return '${regexpMatch.namedGroup('prefix')}${replacements[url] ?? url}'
          '${regexpMatch.namedGroup('suffix')}';
    });
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
    return segment.isEmpty || segment == '.' || segment == '..' ? '_' : segment;
  }

  List<String> _safePathSegments(String path) => path
      .replaceAll('\\', '/')
      .split('/')
      .where((segment) => segment.isNotEmpty)
      .map(_safeSegment)
      .toList(growable: false);
}

sealed class HtmlAssetTarget {
  const HtmlAssetTarget._(this.path);

  const factory HtmlAssetTarget.applicationDocuments({required String path}) =
      _ApplicationDocumentsHtmlAssetTarget;

  const factory HtmlAssetTarget.uri({
    required Uri parent,
    required String path,
  }) = _UriHtmlAssetTarget;

  final String path;
}

final class _ApplicationDocumentsHtmlAssetTarget extends HtmlAssetTarget {
  const _ApplicationDocumentsHtmlAssetTarget({required String path})
    : super._(path);
}

final class _UriHtmlAssetTarget extends HtmlAssetTarget {
  const _UriHtmlAssetTarget({required this.parent, required String path})
    : super._(path);

  final Uri parent;
}
