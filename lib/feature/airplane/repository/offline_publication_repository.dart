part of 'repository.dart';

abstract interface class OfflinePublicationRepository {
  Future<List<PublicationOffline>> getSavedPublications();

  Stream<List<PublicationOffline>> watchSavedPublications();

  Future<void> save(Publication publication);

  Future<void> remove(String id);
}

@dev
@prod
@Singleton(as: OfflinePublicationRepository)
class OfflinePublicationRepositoryImpl implements OfflinePublicationRepository {
  OfflinePublicationRepositoryImpl(this._dao, this._assetService);

  final PublicationDao _dao;
  final HtmlAssetService _assetService;

  static const String _assetRoot = 'db_cache/publication_assets';

  @override
  Stream<List<PublicationOffline>> watchSavedPublications() {
    return _dao.watchAll().handleError((error, stackTrace) {
      throw DatabaseException.from(error);
    });
  }

  @override
  Future<List<PublicationOffline>> getSavedPublications() {
    return _dao.getAll().catchError((error) {
      throw DatabaseException.from(error);
    });
  }

  @override
  Future<void> save(Publication publication) async {
    try {
      final cachedHtml = await _assetService.saveHtml(
        html: publication.textHtml,
        target: HtmlAssetTarget.applicationDocuments(
          path: '$_assetRoot/${publication.id}',
        ),
      );
      final cachedPublication = switch (publication) {
        PublicationCommon common => common.copyWith(textHtml: cachedHtml),
        PublicationPost post => post.copyWith(textHtml: cachedHtml),
        _ => publication,
      };
      await _dao.savePublication(cachedPublication);
    } catch (error) {
      throw DatabaseException.from(error);
    }
  }

  @override
  Future<void> remove(String id) async {
    try {
      await _dao.deletePublication(id);
      await _assetService.delete(
        HtmlAssetTarget.applicationDocuments(path: '$_assetRoot/$id'),
      );
    } catch (error) {
      throw DatabaseException.from(error);
    }
  }
}
