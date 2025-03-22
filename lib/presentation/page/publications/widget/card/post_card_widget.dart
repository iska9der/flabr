import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../core/component/di/di.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../widget/enhancement/enhancement.dart';
import '../stats/publication_stats_widget.dart';
import 'components/footer_widget.dart';
import 'components/header_widget.dart';
import 'components/hubs_widget.dart';
import 'components/publication_type_widget.dart';

class PostCardWidget extends StatelessWidget {
  const PostCardWidget({
    super.key,
    required this.post,
    this.renderType = RenderType.plain,
    this.showType = false,
  });

  final PublicationPost post;
  final RenderType renderType;
  final bool showType;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      onTap:
          () => getIt<AppRouter>().navigate(
            PublicationFlowRoute(type: PublicationType.post.name, id: post.id),
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          if (showType) PublicationTypeWidget(type: post.type),
          PublicationHeaderWidget(post),
          PublicationStatsWidget(post),
          PublicationHubsWidget(hubs: post.hubs),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: HtmlWidget(post.textHtml),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Теги', style: Theme.of(context).textTheme.labelLarge),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    post.tags.map((tag) {
                      final style = Theme.of(context).textTheme.bodySmall;

                      return Text(tag, style: style);
                    }).toList(),
              ),
            ],
          ),
          ArticleFooterWidget(publication: post),
        ],
      ),
    );
  }
}
