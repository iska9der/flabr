import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../core/database/database.dart';
import '../../../data/exception/exception.dart';
import '../../../data/model/publication/publication.dart';

part 'database.g.dart';
part 'publication_dao.dart';
part 'publication_table.dart';

abstract final class AirplaneDbModule {
  static const List<Type> tables = [PublicationTable];
}
