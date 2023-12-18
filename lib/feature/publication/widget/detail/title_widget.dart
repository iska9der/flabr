import 'package:flutter/material.dart';

import '../../model/publication/publication.dart';
import '../../model/publication_type.dart';

class PublicationDetailTitle extends StatelessWidget {
  const PublicationDetailTitle({
    super.key,
    required this.publication,
    this.padding = EdgeInsets.zero,
  });

  final Publication publication;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return switch (publication.type) {
      PublicationType.post => const SizedBox(),
      _ => Padding(
          padding: padding,
          child: SelectableText(
            (publication as PublicationCommon).titleHtml,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
    };
  }
}
