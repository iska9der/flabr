part of 'database.dart';

@DriftAccessor(tables: [PublicationTable])
class PublicationDao extends DatabaseAccessor<AppDatabase>
    with _$PublicationDaoMixin {
  PublicationDao(super.db);

  Future<List<Publication>> getAll() async {
    final rows = await select(publicationTable).get();
    return rows.map((e) => e.toPublication()).toList();
  }

  Stream<List<Publication>> watchAll() {
    return select(publicationTable)
        .watch()
        .handleError((e, s) => throw const DatabaseException())
        .map((rows) => rows.map((e) => e.toPublication()).toList());
  }

  Future<void> insertPublication(Publication entry) =>
      into(publicationTable).insert(entry.toCompanion());

  /// TODO: delete publication from db
  Future<void> deletePublication(String id) => throw UnimplementedError();
}
