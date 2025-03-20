part of 'card.dart';

class PublicationCardWidget extends StatelessWidget {
  const PublicationCardWidget(
    this.publication, {
    super.key,
    this.showType = false,
  });

  final Publication publication;
  final bool showType;

  @override
  Widget build(BuildContext context) {
    return switch (publication.type) {
      PublicationType.post => PostCardWidget(
          post: publication as PublicationPost,
          showType: showType,
        ),
      PublicationType.news || PublicationType.article => CommonCardWidget(
          publication: publication as PublicationCommon,
          showType: showType,
        ),

      /// Неопознанный отлетает в мусорку
      _ => const SizedBox(),
    };
  }
}
