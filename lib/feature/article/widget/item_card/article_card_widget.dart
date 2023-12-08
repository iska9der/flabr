import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../common/model/render_type.dart';
import '../../../../common/widget/enhancement/card.dart';
import '../../../../config/constants.dart';
import '../../../common/image/widget/network_image_widget.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../../model/article_model.dart';
import '../../model/article_type.dart';
import '../../page/detail/article_detail_page.dart';
import '../article_footer_widget.dart';
import '../article_header_widget.dart';
import '../article_hubs_widget.dart';
import '../article_labels_widget.dart';
import '../stats/article_stats_widget.dart';
import 'post_card_widget.dart';

class ArticleCardWidget extends StatelessWidget {
  const ArticleCardWidget({
    super.key,
    required this.article,
    this.renderType = RenderType.plain,
  });

  final ArticleModel article;
  final RenderType renderType;

  @override
  Widget build(BuildContext context) {
    return switch (article.type) {
      /// Неопознанный отлетает в мусорку
      ArticleType.voice => const SizedBox(),
      ArticleType.post => PostCardWidget(article: article),
      _ => FlabrCard(
          onTap: () => context.router.pushWidget(
            ArticleDetailPage(id: article.id),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              ArticleHeaderWidget(article),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: _ArticleTitleWidget(
                  title: article.titleHtml,
                  renderType: renderType,
                ),
              ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (article.leadData.image.isNotEmpty)
                    BlocBuilder<SettingsCubit, SettingsState>(
                      buildWhen: (p, c) =>
                          p.feedConfig.isImageVisible !=
                          c.feedConfig.isImageVisible,
                      builder: (context, state) {
                        if (!state.feedConfig.isImageVisible) {
                          return const SizedBox();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: NetworkImageWidget(
                            imageUrl: article.leadData.image.url,
                            isTapable: true,
                            height: kImageHeightDefault,
                          ),
                        );
                      },
                    ),
                  BlocBuilder<SettingsCubit, SettingsState>(
                    buildWhen: (p, c) =>
                        p.feedConfig.isDescriptionVisible !=
                            c.feedConfig.isDescriptionVisible ||
                        p.feedConfig.isImageVisible !=
                            c.feedConfig.isImageVisible,
                    builder: (context, state) {
                      if (!state.feedConfig.isDescriptionVisible) {
                        return const SizedBox();
                      }

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
                        child: HtmlWidget(
                          article.leadData.textHtml,
                          rebuildTriggers: [
                            state.feedConfig,
                          ],
                          customWidgetBuilder: (element) {
                            if (element.localName == 'img') {
                              if (!state.feedConfig.isImageVisible) {
                                return const SizedBox();
                              }

                              String imgSrc = element.attributes['data-src'] ??
                                  element.attributes['src'] ??
                                  '';

                              if (imgSrc.isEmpty) {
                                return null;
                              }

                              return Align(
                                child: NetworkImageWidget(
                                  imageUrl: imgSrc,
                                  height: kImageHeightDefault,
                                  isTapable: true,
                                ),
                              );
                            }

                            return null;
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ArticleFooterWidget(article: article),
            ],
          ),
        ),
    };
  }
}

class _ArticleTitleWidget extends StatelessWidget {
  const _ArticleTitleWidget({
    required this.title,
    required this.renderType,
  });

  final String title;
  final RenderType renderType;

  @override
  Widget build(BuildContext context) {
    return switch (renderType) {
      RenderType.plain => Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      RenderType.html => HtmlWidget(
          title,
          textStyle: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
          ),
        )
    };
  }
}
