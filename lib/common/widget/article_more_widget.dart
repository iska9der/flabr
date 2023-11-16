import 'package:flutter/material.dart';

import '../../feature/article/model/article_model.dart';

class ArticleMoreOptionsWidget extends StatelessWidget {
  const ArticleMoreOptionsWidget({super.key, required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return TextButtonTheme(
      data: const TextButtonThemeData(
        style: ButtonStyle(alignment: Alignment.centerLeft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.save_alt_rounded),
            label: const Text('Сохранить статью'),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
