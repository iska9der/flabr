import 'package:drift/drift.dart';

import '../../data/model/publication/publication.dart';
import '../../feature/airplane/airplane.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [...AirplaneDbModule.tables],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );
}
