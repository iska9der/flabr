import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../page/article/article_detail_page.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/network_image_widget.dart';
import '../../../config/constants.dart';
import '../model/article_model.dart';
import 'article_author_widget.dart';
import 'article_hub_widget.dart';
import 'article_statistics_widget.dart';

class ArticleCardWidget extends StatelessWidget {
  const ArticleCardWidget({Key? key, required this.article}) : super(key: key);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      padding: const EdgeInsets.all(kCardPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ArticleInfoWidget(article),
          ArticleHubsWidget(hubs: article.hubs),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (article.leadData.image.isNotEmpty) ...[
                const SizedBox(height: 12),
                NetworkImageWidget(
                  imageUrl: article.leadData.image.url,
                  isTapable: true,
                  height: kImageHeightDefault,
                )
              ],
              const SizedBox(height: 12),
              ArticleTitleButton(
                title: article.titleHtml,
                onPressed: () => context.router
                    .pushWidget(ArticleDetailPage(id: article.id)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          ArticleStatisticsWidget(statistics: article.statistics),
        ],
      ),
    );
  }
}

class ArticleInfoWidget extends StatelessWidget {
  const ArticleInfoWidget(this.article, {Key? key}) : super(key: key);

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

class ArticleTitleButton extends StatelessWidget {
  const ArticleTitleButton({
    Key? key,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }
}
