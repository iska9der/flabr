part of 'database.dart';

class PublicationTable extends Table {
  TextColumn get id => text()();
  TextColumn get type => text().map(const PublicationTypeConverter())();
  TextColumn get title => text()();
  TextColumn get publishedAt => text()();
  DateTimeColumn get savedAt => dateTime()();
  TextColumn get payload => text()();

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
