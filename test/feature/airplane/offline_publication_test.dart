import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flabr/core/component/html_asset/html_asset.dart';
import 'package:flabr/core/database/database.dart';
import 'package:flabr/data/model/loading_status_enum.dart';
import 'package:flabr/data/model/publication/publication.dart';
import 'package:flabr/feature/airplane/airplane.dart';
import 'package:flabr/feature/publication_download/publication_download.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Publication offline serialization', () {
    test('round-trips the complete common publication model', () {
      final publication = _publication();

      final restored = Publication.fromJson(publication.toJson());

      expect(restored, publication);
      expect(restored.author.fullname, 'Иван Иванов');
      expect(restored.statistics.readingCount, 42);
      expect(restored.tags, ['Flutter', 'Dart']);
    });
  });

  group('PublicationDao', () {
    late AppDatabase database;
    late PublicationDao dao;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      dao = PublicationDao(database);
    });

    tearDown(() => database.close());

    test('upserts and restores the complete publication', () async {
      final publication = _publication();

      await dao.savePublication(publication);
      await dao.savePublication(
        (publication as PublicationCommon).copyWith(readingTime: 12),
      );
      final saved = await dao.getAll();

      expect(saved, hasLength(1));
      expect(saved.single.publication.author, publication.author);
      expect(
        (saved.single.publication as PublicationCommon).readingTime,
        12,
      );
      expect(saved.single.savedAt, isNotNull);
    });

    test('watchAll emits after save and remove', () async {
      final emissions = <List<PublicationOffline>>[];
      final subscription = dao.watchAll().listen(emissions.add);

      await dao.savePublication(_publication());
      await dao.deletePublication('101');
      await Future<void>.delayed(Duration.zero);

      expect(emissions.any((items) => items.length == 1), isTrue);
      expect(emissions.last, isEmpty);
      await subscription.cancel();
    });
  });

  group('OfflinePublicationRepository', () {
    late AppDatabase database;
    late Directory documentsDirectory;

    setUp(() async {
      database = AppDatabase(NativeDatabase.memory());
      documentsDirectory = await Directory.systemTemp.createTemp(
        'flabr_assets_test_',
      );
    });
    tearDown(() async {
      await database.close();
      await documentsDirectory.delete(recursive: true);
    });

    test('saves idempotently and removes a publication', () async {
      final repository = OfflinePublicationRepositoryImpl(
        PublicationDao(database),
        HtmlAssetService.forTest(
          _FakeAssetDownloader(),
          documentsDirectory: () async => documentsDirectory,
        ),
      );

      await repository.save(_publication());
      await repository.save(_publication());
      expect(await repository.getSavedPublications(), hasLength(1));

      await repository.remove('101');
      expect(await repository.getSavedPublications(), isEmpty);
    });
  });

  group('HtmlAssetService', () {
    test('replaces remote images with stable cache URIs', () async {
      final service = HtmlAssetService(_FakeAssetDownloader());

      final cached = await service.saveHtml(
        html: '<img src="https://example.com/image.png">',
        target: const HtmlAssetTarget.applicationDocuments(
          path: 'db_cache/publication_assets/101',
        ),
      );

      expect(
        cached,
        contains('src="flabr-asset:/db_cache/publication_assets/101/'),
      );
      expect(cached, endsWith('.png">'));
      expect(cached, isNot(contains('https://example.com')));
    });

    test('uses relative asset paths for export', () async {
      final service = HtmlAssetService(_FakeAssetDownloader());

      final exported = await service.saveHtml(
        html: '<img src="https://example.com/image.png">',
        target: HtmlAssetTarget.uri(
          parent: Uri.parse('content://exports'),
          path: '101_assets',
        ),
      );

      expect(exported, contains('src="101_assets/'));
      expect(exported, endsWith('.png">'));
    });

    test('removes remote source sets after localizing image source', () async {
      final service = HtmlAssetService(_FakeAssetDownloader());

      final exported = await service.saveHtml(
        html:
            '<img src="https://example.com/image.webp" '
            'sizes="100vw" '
            'srcset="https://example.com/image-780.webp 780w, '
            'https://example.com/image-1560.webp 1560w">',
        target: HtmlAssetTarget.uri(
          parent: Uri.parse('content://exports'),
          path: '101_assets',
        ),
      );

      expect(exported, contains('src="101_assets/'));
      expect(exported, isNot(contains('srcset=')));
      expect(exported, isNot(contains('https://example.com')));
    });

    test(
      'embeds supported image formats and downloads duplicate once',
      () async {
        final documentsDirectory = await Directory.systemTemp.createTemp(
          'flabr_embedded_assets_test_',
        );
        addTearDown(
          () => documentsDirectory.existsSync()
              ? documentsDirectory.delete(recursive: true)
              : null,
        );
        final downloader = _FakeAssetDownloader(
          applicationDocuments: documentsDirectory,
        );
        final service = HtmlAssetService.forTest(
          downloader,
          documentsDirectory: () async => documentsDirectory,
        );
        const pngUrl = 'https://example.com/image.png';

        final embedded = await service.saveHtml(
          html:
              '<img src="$pngUrl"><img src="$pngUrl">'
              '<img src="https://example.com/image.jpg">'
              '<img src="https://example.com/image.webp">'
              '<img src="https://example.com/image.gif">'
              '<img src="https://example.com/image.svg">',
          target: const HtmlAssetTarget.embedded(path: 'temporary/101'),
        );

        expect(
          RegExp('data:image/png;base64,').allMatches(embedded),
          hasLength(2),
        );
        expect(embedded, contains('data:image/jpeg;base64,'));
        expect(embedded, contains('data:image/webp;base64,'));
        expect(embedded, contains('data:image/gif;base64,'));
        expect(embedded, contains('data:image/svg+xml;base64,'));
        expect(downloader.downloadCalls[pngUrl], 1);
      },
    );

    test('keeps a remote URL when an asset download fails', () async {
      const failedUrl = 'https://example.com/unavailable.png';
      final service = HtmlAssetService(
        _FakeAssetDownloader(failedUrls: const {failedUrl}),
      );

      final result = await service.saveHtml(
        html: '<img src="$failedUrl">',
        target: const HtmlAssetTarget.applicationDocuments(path: 'assets/101'),
      );

      expect(result, contains(failedUrl));
    });

    test('aborts when an asset download fails', () async {
      const failedUrl = 'https://example.com/unavailable.png';
      final service = HtmlAssetService(
        _FakeAssetDownloader(failedUrls: const {failedUrl}),
      );

      expect(
        () => service.saveHtml(
          html: '<img src="$failedUrl">',
          target: const HtmlAssetTarget.applicationDocuments(
            path: 'assets/101',
          ),
          failureStrategy: HtmlAssetFailureStrategy.abort,
        ),
        throwsStateError,
      );
    });

    test(
      'removes failed images and other failed resource references',
      () async {
        const failedUrl = 'https://example.com/unavailable.png';
        final service = HtmlAssetService(
          _FakeAssetDownloader(failedUrls: const {failedUrl}),
        );

        final result = await service.saveHtml(
          html:
              '<p>before</p><img alt="image" src="$failedUrl">'
              '<video poster="$failedUrl"></video><p>after</p>',
          target: const HtmlAssetTarget.applicationDocuments(
            path: 'assets/101',
          ),
          failureStrategy: HtmlAssetFailureStrategy.removeResource,
        );

        expect(result, isNot(contains('<img')));
        expect(result, isNot(contains(failedUrl)));
        expect(result, contains('<video ></video>'));
        expect(result, contains('<p>after</p>'));
      },
    );

    test('deletes temporary embedded assets', () async {
      final documentsDirectory = await Directory.systemTemp.createTemp(
        'flabr_embedded_cleanup_test_',
      );
      addTearDown(
        () => documentsDirectory.existsSync()
            ? documentsDirectory.delete(recursive: true)
            : null,
      );
      final service = HtmlAssetService.forTest(
        _FakeAssetDownloader(applicationDocuments: documentsDirectory),
        documentsDirectory: () async => documentsDirectory,
      );
      const target = HtmlAssetTarget.embedded(path: 'temporary/101');

      await service.saveHtml(
        html: '<img src="https://example.com/image.png">',
        target: target,
      );
      final assetDirectory = Directory(
        p.join(documentsDirectory.path, 'temporary', '101'),
      );
      expect(await assetDirectory.exists(), isTrue);

      await service.delete(target);

      expect(await assetDirectory.exists(), isFalse);
    });

    test('adds responsive image styles to exported HTML', () {
      final converted = PublicationTextConverter.convert(
        text: '<img src="101_assets/image.png">',
        format: PublicationDownloadFormat.html,
      );

      expect(converted, contains('max-width: 100%;'));
      expect(converted, contains('height: auto;'));
    });

    test('resolves stable cache URIs inside application documents', () async {
      final documentsDirectory = Directory(p.absolute('tmp', 'documents'));
      final service = HtmlAssetService.forTest(
        _FakeAssetDownloader(),
        documentsDirectory: () async => documentsDirectory,
      );

      final resolved = await service.resolveUri(
        'flabr-asset:/db_cache/publication_assets/101/image.png',
      );

      expect(
        resolved?.toFilePath(),
        p.absolute(
          p.join(
            documentsDirectory.path,
            'db_cache',
            'publication_assets',
            '101',
            'image.png',
          ),
        ),
      );
    });
  });

  group('OfflinePublicationBloc', () {
    test('tracks stream data and serializes duplicate save requests', () async {
      final repository = _FakeRepository();
      final bloc = OfflinePublicationBloc(repository: repository);

      bloc.add(const OfflinePublicationEvent.load());
      await _flushEvents();
      repository.emit([_savedPublication()]);
      await _flushEvents();

      expect(bloc.state.status, LoadingStatus.success);
      expect(bloc.state.savedIds, {'101'});

      bloc
        ..add(
          OfflinePublicationEvent.setSaved(
            publication: _publication(),
            saved: true,
          ),
        )
        ..add(
          OfflinePublicationEvent.setSaved(
            publication: _publication(),
            saved: true,
          ),
        );
      await Future<void>.delayed(const Duration(milliseconds: 20));

      expect(repository.saveCalls, 2);
      await bloc.close();
      await repository.close();
    });
  });
}

class _FakeAssetDownloader implements HtmlAssetDownloader {
  _FakeAssetDownloader({
    this.applicationDocuments,
    this.failedUrls = const {},
  });

  final Directory? applicationDocuments;
  final Set<String> failedUrls;
  final Map<String, int> downloadCalls = {};

  @override
  Future<Uri> createDirectory(Uri parent, String name) =>
      Future.value(Uri.parse('${parent.toString()}/$name'));

  @override
  Future<Uri?> downloadToApplicationDocuments({
    required String url,
    required String directory,
    required String filename,
  }) async {
    downloadCalls.update(url, (count) => count + 1, ifAbsent: () => 1);
    if (failedUrls.contains(url)) return null;
    if (applicationDocuments == null) return Uri.file('$directory/$filename');

    final file = File(
      p.join(applicationDocuments!.path, directory, filename),
    );
    await file.parent.create(recursive: true);
    await file.writeAsBytes(const [1, 2, 3]);
    return file.uri;
  }

  @override
  Future<Uri?> downloadToUri({
    required String url,
    required Uri directory,
    required String filename,
  }) async => Uri.parse('${directory.toString()}/$filename');
}

Publication _publication() => const PublicationSealed.common(
  id: '101',
  type: PublicationType.article,
  titleHtml: 'Полная статья',
  textHtml: '<p>Текст без сетевых ресурсов</p>',
  timePublished: '2026-07-18T10:00:00+03:00',
  author: PublicationAuthor(
    id: '7',
    alias: 'ivan',
    fullname: 'Иван Иванов',
  ),
  statistics: PublicationStatistics(readingCount: 42),
  tags: ['Flutter', 'Dart'],
  readingTime: 8,
);

PublicationOffline _savedPublication() => PublicationOffline(
  publication: _publication(),
  savedAt: DateTime(2026, 7, 18),
);

Future<void> _flushEvents() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

class _FakeRepository implements OfflinePublicationRepository {
  final StreamController<List<PublicationOffline>> _controller =
      StreamController.broadcast();

  int saveCalls = 0;

  void emit(List<PublicationOffline> publications) =>
      _controller.add(publications);

  Future<void> close() => _controller.close();

  @override
  Future<List<PublicationOffline>> getSavedPublications() async => const [];

  @override
  Future<void> remove(String id) async {}

  @override
  Future<void> save(Publication publication) async {
    saveCalls++;
    await Future<void>.delayed(const Duration(milliseconds: 1));
  }

  @override
  Stream<List<PublicationOffline>> watchSavedPublications() =>
      _controller.stream;
}
