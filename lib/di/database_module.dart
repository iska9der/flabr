import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../core/database/database.dart';

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'flabr_db',
    native: DriftNativeOptions(
      databaseDirectory: getApplicationDocumentsDirectory,
      tempDirectoryPath: () async => (await getTemporaryDirectory()).path,
    ),
  );
}

@prod
@dev
@module
abstract class DatabaseModule {
  @lazySingleton
  QueryExecutor executor() => _openConnection();

  @lazySingleton
  AppDatabase appDatabase(QueryExecutor executor) => AppDatabase(executor);
}
