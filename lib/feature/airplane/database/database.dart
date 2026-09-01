import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../core/database/database.dart';
import '../../../data/model/publication/publication.dart';
import '../model/publication_offline.dart';

part 'database.g.dart';
part 'publication_dao.dart';
part 'publication_table.dart';

extension PublicationMapper on PublicationTableData {
  PublicationOffline toPublicationOffline() => PublicationOffline(
    publication: Publication.fromJson(
      Map<String, dynamic>.from(jsonDecode(payload) as Map),
    ),
    savedAt: savedAt,
  );
}

extension PublicationCompanionMapper on Publication {
  PublicationTableCompanion toCompanion({required DateTime savedAt}) =>
      PublicationTableCompanion(
        id: Value(id),
        type: Value(type),
        title: Value(switch (this) {
          PublicationPost _ => '',
          PublicationCommon common => common.titleHtml,
          _ => '',
        }),
        publishedAt: Value(timePublished),
        savedAt: Value(savedAt),
        payload: Value(jsonEncode(toJson())),
      );
}

abstract final class AirplaneDbModule {
  static const List<Type> tables = [PublicationTable];
}
