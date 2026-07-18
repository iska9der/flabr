part of 'repository.dart';

abstract interface class OfflinePublicationRepository {
  Future<List<Publication>> getAll();

  Stream<List<Publication>> watchAll();

  Future<void> save(Publication publication);

  Future<void> remove(String id);
}

@dev
@prod
@Singleton(as: OfflinePublicationRepository)
class OfflinePublicationRepositoryImpl implements OfflinePublicationRepository {
  OfflinePublicationRepositoryImpl(this._dao);

  final PublicationDao _dao;

  @override
  Stream<List<Publication>> watchAll() {
    return _dao.watchAll().handleError((error, stackTrace) {
      throw DatabaseException.from(error);
    });
  }

  @override
  Future<List<Publication>> getAll() {
    return _dao.getAll().catchError((error) {
      throw DatabaseException.from(error);
    });
  }

  @override
  Future<void> save(Publication publication) async {
    try {
      await _dao.insertPublication(publication);
    } catch (error) {
      throw DatabaseException.from(error);
    }
  }

  @override
  Future<void> remove(String id) async {
    try {
      await _dao.deletePublication(id);
    } catch (error) {
      throw DatabaseException.from(error);
    }
  }
}
