import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../data/model/publication/publication.dart';
import '../../../../../widget/author_widget.dart';

class PublicationHeaderWidget extends StatelessWidget {
  const PublicationHeaderWidget(this.publication, {super.key});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AuthorWidget(publication.author),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            DateFormat.yMMMMd().add_jm().format(publication.publishedAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}