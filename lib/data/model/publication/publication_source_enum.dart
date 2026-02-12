part of 'publication.dart';

enum PublicationSource {
  article,
  post,
  news;

  factory PublicationSource.fromType(PublicationType type) {
    return PublicationSource.values.firstWhere(
      (source) => source.name == type.name,
      orElse: () => PublicationSource.article,
    );
  }
}
