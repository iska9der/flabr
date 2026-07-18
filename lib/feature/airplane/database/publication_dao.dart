part of 'database.dart';

@lazySingleton
@DriftAccessor(tables: [PublicationTable])
class PublicationDao extends DatabaseAccessor<AppDatabase>
    with _$PublicationDaoMixin {
  PublicationDao(super.db);

  Future<List<PublicationOffline>> getAll() async {
    final rows = await _orderedQuery().get();
    return rows.map((row) => row.toPublicationOffline()).toList();
  }

  Stream<List<PublicationOffline>> watchAll() {
    return _orderedQuery().watch().map(
      (rows) => rows.map((row) => row.toPublicationOffline()).toList(),
    );
  }

  Future<void> savePublication(Publication publication) =>
      into(publicationTable).insertOnConflictUpdate(
        publication.toCompanion(savedAt: DateTime.now()),
      );

  Future<void> deletePublication(String id) {
    final statement = delete(publicationTable)
      ..where((tbl) => tbl.id.equals(id));

    return statement.go();
  }

  SimpleSelectStatement<$PublicationTableTable, PublicationTableData>
  _orderedQuery() => select(publicationTable)
    ..orderBy([
      (table) => OrderingTerm(
        expression: table.savedAt,
        mode: OrderingMode.desc,
      ),
    ]);
}
