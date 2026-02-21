part of 'database.dart';

@lazySingleton
@DriftAccessor(tables: [PublicationTable])
class PublicationDao extends DatabaseAccessor<AppDatabase>
    with _$PublicationDaoMixin {
  PublicationDao(super.db);

  Future<List<Publication>> getAll() async {
    final rows = await select(publicationTable).get();
    return rows.map((e) => e.toPublication()).toList();
  }

  Stream<List<Publication>> watchAll() {
    return select(
      publicationTable,
    ).watch().map((rows) => rows.map((e) => e.toPublication()).toList());
  }

  Future<void> insertPublication(Publication entry) =>
      into(publicationTable).insert(entry.toCompanion());

  Future<void> deletePublication(String id) {
    final statement = delete(publicationTable)
      ..where((tbl) => tbl.id.equals(id));

    return statement.go();
  }
}
