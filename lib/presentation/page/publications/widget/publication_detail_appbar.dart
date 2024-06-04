part of 'publication_detail_view.dart';

class PublicationDetailAppBarTitle extends StatelessWidget {
  const PublicationDetailAppBarTitle({super.key, required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    final title = switch (publication.type) {
      PublicationType.post => 'Пост',
      _ => (publication as PublicationCommon).titleHtml,
    };

    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}
