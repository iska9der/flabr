import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../model/article_model.dart';
import 'more/save_expansion_widget.dart';

class ArticleMoreOptionsWidget extends StatelessWidget {
  const ArticleMoreOptionsWidget({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return TextButtonTheme(
      data: const TextButtonThemeData(
        style: ButtonStyle(alignment: Alignment.centerLeft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kScreenHPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SaveExpansionWidget(article: article),
          ],
        ),
      ),
    );
  }
}
