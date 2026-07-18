part of 'database.dart';

class PublicationTable extends Table {
  TextColumn get id => text()();
  TextColumn get type => text().map(const PublicationTypeConverter())();
  TextColumn get title => text().nullable()();
  TextColumn get content => text()();
  TextColumn get publishedAt => text()();

  @override
  Set<Column> get primaryKey => {id};
}

class PublicationTypeConverter extends TypeConverter<PublicationType, String> {
  const PublicationTypeConverter();

  @override
  PublicationType fromSql(String fromDb) {
    return PublicationType.fromString(fromDb);
  }

  @override
  String toSql(PublicationType value) => value.name;
}

extension PublicationMapper on PublicationTableData {
  Publication toPublication() => PublicationSealed.common(
    id: id,
    type: type,
    titleHtml: title ?? '',
    textHtml: content,
    timePublished: publishedAt,
  );
}

extension PublicationCompanionMapper on Publication {
  PublicationTableCompanion toCompanion() => PublicationTableCompanion(
    id: Value(id),
    type: Value(type),
    title: Value(switch (this) {
      PublicationPost _ => null,
      PublicationCommon common => common.titleHtml,
      _ => null,
    }),
    content: Value(textHtml),
    publishedAt: Value(timePublished),
  );
}
