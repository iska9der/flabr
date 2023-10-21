import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/article_model.dart';
import 'article_author_widget.dart';

class ArticleHeaderWidget extends StatelessWidget {
  const ArticleHeaderWidget(this.article, {super.key});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ArticleAuthorWidget(article.author),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            DateFormat.yMMMMd().add_jm().format(article.publishedAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
