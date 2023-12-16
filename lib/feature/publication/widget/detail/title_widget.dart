import 'package:flutter/material.dart';

import '../../model/common_model.dart';
import '../../model/publication.dart';
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
            (publication as CommonModel).titleHtml,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
    };
  }
}
