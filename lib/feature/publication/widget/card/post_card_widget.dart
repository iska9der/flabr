import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../common/model/render_type.dart';
import '../../../../common/widget/enhancement/card.dart';
import '../../../../component/di/dependencies.dart';
import '../../../../component/router/app_router.dart';
import '../../model/publication/publication.dart';
import '../../page/post/post_detail_page.dart';
import '../stats/stats_widget.dart';
import 'components/footer_widget.dart';
import 'components/header_widget.dart';
import 'components/hubs_widget.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
    super.key,
    required this.post,
    this.renderType = RenderType.plain,
  });

  final PublicationPost post;
  final RenderType renderType;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      onTap: () => getIt.get<AppRouter>().pushWidget(
            PostDetailPage(id: post.id),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          PublicationHeaderWidget(post),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
            child: PublicationStatsWidget(post),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: PublicationHubsWidget(hubs: post.hubs),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
            child: HtmlWidget(
              post.textHtml,
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
                  children: post.tags.map((tag) {
                    final style = Theme.of(context).textTheme.bodySmall;

                    return Text(tag, style: style);
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ArticleFooterWidget(publication: post),
        ],
      ),
    );
  }
}
