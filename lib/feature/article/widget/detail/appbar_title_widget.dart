import 'package:flutter/material.dart';

import '../../model/article_model.dart';
import '../../model/article_type.dart';

class ArticleDetailAppBarTitle extends StatelessWidget {
  const ArticleDetailAppBarTitle({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final title = switch (article.type) {
      ArticleType.post => 'Пост',
      _ => article.titleHtml,
    };

    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.titleSmall,
    );
  }
}
