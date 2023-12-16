import 'package:flutter/material.dart';

import '../../model/common_model.dart';
import '../../model/post/post_model.dart';
import '../../model/publication.dart';
import '../../model/publication_type.dart';
import 'article_card_widget.dart';
import 'post_card_widget.dart';

class PublicationCardWidget extends StatelessWidget {
  const PublicationCardWidget(this.publication, {super.key});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return switch (publication.type) {
      /// Неопознанный отлетает в мусорку
      PublicationType.voice => const SizedBox(),
      PublicationType.post => PostCardWidget(post: publication as PostModel),
      _ => CommonCardWidget(publication: publication as CommonModel),
    };
  }
}
