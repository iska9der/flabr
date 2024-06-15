import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../data/model/publication/publication_type_enum.dart';
import 'articles/article_comment_page.dart';
import 'articles/article_detail_page.dart';
import 'news/news_comment_page.dart';
import 'posts/post_comment_page.dart';

@RoutePage(name: PublicationCommentPage.routeName)
class PublicationCommentPage extends StatelessWidget {
  PublicationCommentPage({
    super.key,
    @PathParam.inherit() required String type,
    @PathParam.inherit() required this.id,
  }) : type = PublicationType.fromString(type);

  final PublicationType type;
  final String id;

  static const String routePath = 'comments';
  static const String routeName = 'PublicationCommentRoute';

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      PublicationType.post => PostCommentListPage(id: id),
      PublicationType.news => NewsCommentListPage(id: id),
      PublicationType.article => ArticleCommentListPage(id: id),

      /// Неопознанный открываем как статью
      _ => ArticleDetailPage(id: id),
    };
  }
}
