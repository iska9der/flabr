import 'package:freezed_annotation/freezed_annotation.dart';

import '../publication/publication.dart';

part 'publication_criteria.freezed.dart';
part 'publication_criteria.g.dart';

@freezed
abstract class PublicationCriteria with _$PublicationCriteria {
  const PublicationCriteria._();

  const factory PublicationCriteria({
    PublicationComplexity? complexity,
    @Default(PublicationFormat.values) List<PublicationFormat> formats,
  }) = _PublicationCriteria;

  factory PublicationCriteria.fromJson(Map<String, dynamic> json) =>
      _$PublicationCriteriaFromJson(json);

  Map<String, String> toQuery({bool personal = false}) => {
    if (complexity != null || personal)
      'complexity': complexity?.filterValue ?? 'all',
    if (personal || formats.length != PublicationFormat.values.length)
      for (var i = 0; i < formats.length; i++)
        'formats[$i]': formats[i].apiValue,
  };

  bool matches(PublicationCommon article) =>
      (complexity == null || complexity == article.complexity) &&
      formats.contains(article.format ?? PublicationFormat.common);
}
