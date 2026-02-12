part of 'publication.dart';

/// Метка поста (например, "Перевод", "Recovery Mode" и т.д.)
@freezed
abstract class PostLabel with _$PostLabel {
  const PostLabel._();

  const factory PostLabel({
    required String type,
    required String typeOf,
    required String title,
    required PostLabelData data,
  }) = _PostLabel;

  factory PostLabel.fromJson(Map<String, dynamic> json) =>
      _$PostLabelFromJson(json);

  PostLabelType get typeEnum => PostLabelType.fromString(type);
}

/// Данные внутри метки поста (например, автор перевода, ссылка и т.д.)
@freezed
abstract class PostLabelData with _$PostLabelData {
  const factory PostLabelData({
    String? originalAuthorName,
    String? originalUrl,
  }) = _PostLabelData;

  factory PostLabelData.fromJson(Map<String, dynamic> json) =>
      _$PostLabelDataFromJson(json);
}
