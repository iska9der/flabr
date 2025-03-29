import 'package:flutter/material.dart';

import '../../../../../data/model/publication/publication.dart';
import 'common_card_widget.dart';
import 'post_card_widget.dart';

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
    final key = Key('publication_card_${publication.id}');

    return switch (publication.type) {
      PublicationType.post => PostCardWidget(
        key: key,
        post: publication as PublicationPost,
        showType: showType,
      ),
      PublicationType.news || PublicationType.article => CommonCardWidget(
        key: key,
        publication: publication as PublicationCommon,
        showType: showType,
      ),

      /// Неопознанный отлетает в мусорку
      _ => const SizedBox(),
    };
  }
}
