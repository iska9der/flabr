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

  DateTime get publishedAt => DateTime.parse(timePublished).toLocal();

  static const empty = PublicationCommon(id: '0');
  bool get isEmpty => this == empty;

  factory Publication.fromJson(Map<String, dynamic> json) =>
      PublicationSealed.fromJson(json);
}

/// Базовый класс с общими свойствами
@freezed
sealed class PublicationSealed with _$PublicationSealed implements Publication {
  const PublicationSealed._();

  const factory PublicationSealed(
    @PublicationResponseConverter() PublicationSealed myResponse,
  ) = PublicationData;

  /// Статья/новость
  @Implements<Publication>()
  const factory PublicationSealed.common({
    required String id,
    @Default(PublicationType.unknown) PublicationType type,
    @Default('2022-12-22T10:10:00+00:00') String timePublished,
    @Default('') String textHtml,
    @Default(PublicationAuthor.empty) PublicationAuthor author,
    @Default(PublicationStatistics.empty) PublicationStatistics statistics,
    @Default(PublicationRelatedData.empty) PublicationRelatedData relatedData,
    @Default([]) List<PublicationHub> hubs,
    @Default([]) List<String> tags,
    @Default('') String titleHtml,
    @Default(PublicationLeadData.empty) PublicationLeadData leadData,
    PublicationComplexity? complexity,
    @Default(0) int readingTime,
    PublicationFormat? format,
    @Default([]) List<PostLabel> postLabels,
  }) = PublicationCommon;

  /// Пост
  @Implements<Publication>()
  const factory PublicationSealed.post({
    required String id,
    @Default(PublicationType.post) PublicationType type,
    @Default('2022-12-22T10:10:00+00:00') String timePublished,
    @Default('') String textHtml,
    @Default(PublicationAuthor.empty) PublicationAuthor author,
    @Default(PublicationStatistics.empty) PublicationStatistics statistics,
    @Default(PublicationRelatedData.empty) PublicationRelatedData relatedData,
    @Default([]) List<PublicationHub> hubs,
    @Default([]) List<String> tags,
  }) = PublicationPost;

  factory PublicationSealed.fromJson(Map<String, dynamic> json) =>
      _$PublicationSealedFromJson(json);
}

class PublicationResponseConverter
    implements JsonConverter<PublicationSealed, Map<String, dynamic>> {
  const PublicationResponseConverter();

  @override
  PublicationSealed fromJson(Map<String, dynamic> json) {
    // type data was already set (e.g. because we serialized it ourselves)
    if (json['runtimeType'] != null) {
      return PublicationSealed.fromJson(json);
    }

    final String? typeValue = json['publicationType'] ?? json['postType'];

    final resolvedType = switch (typeValue != null) {
      true => PublicationType.fromString(typeValue!),
      false => PublicationType.unknown,
    };

    return switch (resolvedType) {
      PublicationType.article ||
      PublicationType.news => PublicationCommon.fromJson(json),
      PublicationType.post => PublicationPost.fromJson(json),
      _ => PublicationCommon.fromJson(json),
    };
  }

  @override
  Map<String, dynamic> toJson(PublicationSealed data) => data.toJson();
}
