import 'package:flutter/material.dart';

class UserArticlePage extends StatelessWidget {
  const UserArticlePage({Key? key}) : super(key: key);

  static const String title = 'Публикации';
  static const String routePath = 'article';
  static const String routeName = 'UserArticleRoute';

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Публикации'),
    );
  }
}
