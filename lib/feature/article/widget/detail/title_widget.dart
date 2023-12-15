import 'package:flutter/material.dart';

import '../../../publication/model/article/article_model.dart';
import '../../../publication/model/publication_type.dart';

class ArticleDetailTitle extends StatelessWidget {
  const ArticleDetailTitle(
      {super.key, required this.article, this.padding = EdgeInsets.zero});

  final ArticleModel article;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return switch (article.type) {
      PublicationType.post => const SizedBox(),
      _ => Padding(
          padding: padding,
          child: SelectableText(
            article.titleHtml,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
    };
  }
}
