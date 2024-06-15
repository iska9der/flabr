import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../data/model/publication/publication_type_enum.dart';
import 'articles/article_detail_page.dart';
import 'news/news_detail_page.dart';
import 'posts/post_detail_page.dart';

@RoutePage(name: PublicationDetailPage.routeName)
class PublicationDetailPage extends StatelessWidget {
  PublicationDetailPage({
    super.key,
    @PathParam.inherit() required String type,
    @PathParam.inherit() required this.id,
  }) : type = PublicationType.fromString(type);

  final PublicationType type;
  final String id;

  static const String routePath = '';
  static const String routeName = 'PublicationDetailRoute';

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      PublicationType.post => PostDetailPage(id: id),
      PublicationType.news => NewsDetailPage(id: id),
      PublicationType.article => ArticleDetailPage(id: id),

      /// Неопознанный открываем как статью
      _ => ArticleDetailPage(id: id),
    };
  }
}
