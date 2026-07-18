import '../../../data/model/publication/publication.dart';

class PublicationOffline {
  const PublicationOffline({
    required this.publication,
    required this.savedAt,
  });

  final Publication publication;
  final DateTime savedAt;
}
