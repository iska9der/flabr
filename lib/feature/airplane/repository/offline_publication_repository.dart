part of 'repository.dart';

abstract interface class OfflinePublicationRepository {
  FutureOr<List<Publication>> getAll();

  Stream<List<Publication>> watchAll();

  Future<void> create(Publication publication);

  Future<void> delete(String id);
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
  FutureOr<List<Publication>> getAll() {
    return _dao.getAll().catchError((error) {
      throw DatabaseException.from(error);
    });
  }

  @override
  Future<void> create(Publication publication) async {
    try {
      await _dao.insertPublication(publication);
    } catch (error) {
      throw DatabaseException.from(error);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _dao.deletePublication(id);
    } catch (error) {
      throw DatabaseException.from(error);
    }
  }
}
