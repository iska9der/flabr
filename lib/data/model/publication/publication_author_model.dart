part of 'publication.dart';

@freezed
abstract class PublicationAuthor with _$PublicationAuthor implements UserBase {
  const PublicationAuthor._();

  @Implements<UserBase>()
  const factory PublicationAuthor({
    required String id,
    @Default('') String alias,
    @Default('') String fullname,
    @Default('') String avatarUrl,
    @Default('') String speciality,
  }) = _PublicationAuthor;

  factory PublicationAuthor.fromJson(Map<String, dynamic> json) =>
      _$PublicationAuthorFromJson(json);

  static const empty = PublicationAuthor(id: '0');
}
