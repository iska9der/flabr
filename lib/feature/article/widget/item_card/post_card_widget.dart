import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../common/model/render_type.dart';
import '../../../../common/widget/enhancement/card.dart';
import '../../../publication/model/article/article_model.dart';
import '../../../publication/page/post_detail_page.dart';
import '../article_footer_widget.dart';
import '../article_header_widget.dart';
import '../article_hubs_widget.dart';
import '../article_labels_widget.dart';
import '../stats/article_stats_widget.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
    super.key,
    required this.article,
    this.renderType = RenderType.plain,
  });

  final ArticleModel article;
  final RenderType renderType;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      onTap: () => context.router.pushWidget(
        PostDetailPage(id: article.id),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ArticleHeaderWidget(article),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
            child: ArticleStatsWidget(article),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: ArticleHubsWidget(hubs: article.hubs),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: ArticleLabelsWidget(article),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
            child: HtmlWidget(
              article.textHtml,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Теги',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: article.tags.map((tag) {
                    final style = Theme.of(context).textTheme.bodySmall;

                    return Text(tag, style: style);
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ArticleFooterWidget(article: article),
        ],
      ),
    );
  }
}
