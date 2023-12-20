import 'package:flutter/material.dart';

import '../../model/publication/publication.dart';
import '../../model/publication_type.dart';
import 'common_card_widget.dart';
import 'post_card_widget.dart';

class PublicationCardWidget extends StatelessWidget {
  const PublicationCardWidget(this.publication, {super.key});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return switch (publication.type) {
      /// Неопознанный отлетает в мусорку
      PublicationType.voice => const SizedBox(),
      PublicationType.post =>
        PostCardWidget(post: publication as PublicationPost),
      _ => CommonCardWidget(publication: publication as PublicationCommon),
    };
  }
}
