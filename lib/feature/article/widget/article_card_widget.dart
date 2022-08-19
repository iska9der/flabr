import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/widget/progress_indicator.dart';
import '../../../components/router/router.gr.dart';
import '../../../config/constants.dart';
import '../model/article_model.dart';
import 'article_statistics_widget.dart';

class ArticleCardWidget extends StatelessWidget {
  const ArticleCardWidget({Key? key, required this.article}) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ArticleAuthorWidget(article),
            Column(
              children: [
                if (article.leadData.image.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  CachedNetworkImage(
                    placeholder: (c, url) => const SizedBox(
                      height: postImageHeight,
                      child: CircleIndicator.small(),
                    ),
                    height: postImageHeight,
                    imageUrl: article.leadData.image.url,
                  )
                ],
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      context.router.push(ArticleRoute(id: article.id)),
                  child: Text(
                    article.titleHtml,
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            ArticleStatisticsWidget(statistics: article.statistics),
          ],
        ),
      ),
    );
  }
}

class ArticleAuthorWidget extends StatelessWidget {
  const ArticleAuthorWidget(this.article, {Key? key}) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final timePub =
        "${DateFormat.yMMMMd().format(article.publishedAt)}, ${DateFormat.Hm().format(article.publishedAt)}";

    return Row(
      children: [
        Text(
          timePub,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
