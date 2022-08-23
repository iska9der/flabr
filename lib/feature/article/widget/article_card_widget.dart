import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../common/widget/network_image_widget.dart';
import '../../../component/router/router.gr.dart';
import '../../../config/constants.dart';
import '../model/article_model.dart';
import 'article_author_widget.dart';
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
            ArticleTopRow(article),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (article.leadData.image.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  NetworkImageWidget(
                    url: article.leadData.image.url,
                    height: postImageHeight,
                  )
                ],
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.router.push(
                    ArticleDetailRoute(id: article.id),
                  ),
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(defaultBorderRadius),
                      ),
                    ),
                  ),
                  child: Text(
                    article.titleHtml,
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

class ArticleTopRow extends StatelessWidget {
  const ArticleTopRow(this.article, {Key? key}) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final timePub =
        '${DateFormat.yMMMMd().format(article.publishedAt)}, ${DateFormat.Hm().format(article.publishedAt)}';

    return Row(
      children: [
        ArticleAuthorWidget(article.author),
        const SizedBox(width: 4),
        Text(
          timePub,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
