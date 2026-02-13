part of 'publication.dart';

abstract interface class Publication {
  String get id;
  PublicationType get type;
  String get timePublished;
  String get textHtml;
  PublicationAuthor get author;
  PublicationStatistics get statistics;
  PublicationRelatedData get relatedData;
  List<PublicationHub> get hubs;
  List<String> get tags;

  DateTime get publishedAt;

  static const PublicationCommon empty = .new(id: '0');
  bool get isEmpty;

  factory Publication.fromJson(Map<String, dynamic> json) =>
      PublicationSealed.fromJson(json);

  Map<String, dynamic> toJson();
}

/// Базовый класс с общими свойствами
@freezed
sealed class PublicationSealed with _$PublicationSealed implements Publication {
  const PublicationSealed._();

  /// Статья/новость
  @Implements<Publication>()
  const factory PublicationSealed.common({
    required String id,
    @JsonKey(readValue: _typeReader, unknownEnumValue: PublicationType.unknown)
    @Default(PublicationType.unknown)
    PublicationType type,
    @Default('2022-12-22T10:10:00+00:00') String timePublished,
    @Default('') String textHtml,
    @Default(PublicationAuthor.empty) PublicationAuthor author,
    @Default(PublicationStatistics.empty) PublicationStatistics statistics,
    @Default(PublicationRelatedData.empty) PublicationRelatedData relatedData,
    @Default([]) List<PublicationHub> hubs,
    @JsonKey(readValue: _tagsReader) @Default([]) List<String> tags,
    @Default('') String titleHtml,
    @Default(PublicationLeadData.empty) PublicationLeadData leadData,
    PublicationComplexity? complexity,
    @Default(0) int readingTime,
    @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
    PublicationFormat? format,
    @Default([]) List<PostLabel> postLabels,
  }) = PublicationCommon;

  /// Пост
  @Implements<Publication>()
  const factory PublicationSealed.post({
    required String id,
    @JsonKey(readValue: _typeReader, unknownEnumValue: PublicationType.unknown)
    @Default(PublicationType.post)
    PublicationType type,
    @Default('2022-12-22T10:10:00+00:00') String timePublished,
    @Default('') String textHtml,
    @Default(PublicationAuthor.empty) PublicationAuthor author,
    @Default(PublicationStatistics.empty) PublicationStatistics statistics,
    @Default(PublicationRelatedData.empty) PublicationRelatedData relatedData,
    @Default([]) List<PublicationHub> hubs,
    @JsonKey(readValue: _tagsReader) @Default([]) List<String> tags,
  }) = PublicationPost;

  factory PublicationSealed.fromJson(Map<String, dynamic> json) =>
      const PublicationResponseConverter().fromJson(json);

  @override
  DateTime get publishedAt => .parse(timePublished).toLocal();

  @override
  bool get isEmpty => this == Publication.empty;
}

class PublicationResponseConverter
    implements JsonConverter<PublicationSealed, Map<String, dynamic>> {
  const PublicationResponseConverter();

  @override
  PublicationSealed fromJson(Map<String, dynamic> json) {
    final String? typeValue = json['publicationType'] ?? json['postType'];

    final PublicationType resolvedType = switch (typeValue != null) {
      true => .fromString(typeValue!),
      false => .unknown,
    };

    return switch (resolvedType) {
      .article || .news => PublicationCommon.fromJson(json),
      .post => PublicationPost.fromJson(json),
      _ => PublicationCommon.fromJson(json),
    };
  }

  @override
  Map<String, dynamic> toJson(PublicationSealed data) => data.toJson();
}

Object? _tagsReader(Map<dynamic, dynamic> json, String key) {
  if (key == 'tags') {
    return List<Map<String, dynamic>>.from(
      json['tags'] ?? [],
    ).map((tag) => tag['titleHtml']).toList();
  }

  return json[key];
}

Object? _typeReader(Map<dynamic, dynamic> json, String key) {
  if (key == 'type') {
    return json['postType'] ?? json['publicationType'];
  }

  return json[key];
}
