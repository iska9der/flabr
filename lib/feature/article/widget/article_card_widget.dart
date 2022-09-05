import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';

import '../../../common/model/render_type.dart';
import '../../../config/constants.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/html_view_widget.dart';
import '../../../widget/network_image_widget.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../model/article_model.dart';
import '../page/article_detail_page.dart';
import 'article_author_widget.dart';
import 'article_hub_widget.dart';
import 'article_statistics_widget.dart';

class ArticleCardWidget extends StatelessWidget {
  const ArticleCardWidget({
    Key? key,
    required this.article,
    this.renderType = RenderType.plain,
  }) : super(key: key);

  final ArticleModel article;
  final RenderType renderType;

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
              if (article.leadData.image.isNotEmpty)
                BlocBuilder<SettingsCubit, SettingsState>(
                  buildWhen: (p, c) =>
                      p.feedConfig.isImageVisible !=
                      c.feedConfig.isImageVisible,
                  builder: (context, state) {
                    if (!state.feedConfig.isImageVisible) return Wrap();

                    return Column(
                      children: [
                        const SizedBox(height: 12),
                        NetworkImageWidget(
                          imageUrl: article.leadData.image.url,
                          isTapable: true,
                          height: kImageHeightDefault,
                        )
                      ],
                    );
                  },
                ),
              const SizedBox(height: 12),
              _ArticleTitleWidget(
                title: article.titleHtml,
                renderType: renderType,
                onPressed: () => context.router.pushWidget(
                  ArticleDetailPage(id: article.id),
                ),
              ),
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (p, c) =>
                    p.feedConfig.isDescriptionVisible !=
                        c.feedConfig.isDescriptionVisible ||
                    p.feedConfig.isImageVisible != c.feedConfig.isImageVisible,
                builder: (context, state) {
                  if (!state.feedConfig.isDescriptionVisible) return Wrap();

                  return HtmlView(
                    textHtml: article.leadData.textHtml,
                    renderMode: RenderMode.column,
                    customWidgetBuilder: !state.feedConfig.isImageVisible
                        ? (element) {
                            if (element.localName == 'img') {
                              if (!state.feedConfig.isImageVisible) {
                                return Wrap();
                              }
                            }

                            return null;
                          }
                        : null,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 30),
          ArticleStatisticsWidget(
            articleId: article.id,
            statistics: article.statistics,
          ),
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
    return Row(
      children: [
        ArticleAuthorWidget(article.author),
        const SizedBox(width: 4),
        Text(
          DateFormat.yMMMMd().add_jm().format(article.publishedAt),
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}

class _ArticleTitleWidget extends StatelessWidget {
  const _ArticleTitleWidget({
    Key? key,
    required this.title,
    required this.renderType,
    required this.onPressed,
  }) : super(key: key);

  final String title;
  final RenderType renderType;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return renderType == RenderType.plain
        ? TextButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
          )
        : TextButton(
            onPressed: onPressed,
            child: HtmlWidget(
              title,
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.headline6?.color,
                fontSize: Theme.of(context).textTheme.headline6?.fontSize,
              ),
            ),
          );
  }
}
