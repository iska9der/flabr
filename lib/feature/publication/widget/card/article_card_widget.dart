import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../common/model/render_type.dart';
import '../../../../common/widget/enhancement/card.dart';
import '../../../../config/constants.dart';
import '../../../common/image/widget/network_image_widget.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../../model/publication/publication.dart';
import '../../page/article_detail_page.dart';
import '../stats/stats_widget.dart';
import 'components/footer_widget.dart';
import 'components/format_widget.dart';
import 'components/header_widget.dart';
import 'components/hubs_widget.dart';

class CommonCardWidget extends StatelessWidget {
  const CommonCardWidget({
    super.key,
    required this.publication,
    this.renderType = RenderType.plain,
  });

  final PublicationCommon publication;
  final RenderType renderType;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      onTap: () => context.router.pushWidget(
        ArticleDetailPage(id: publication.id),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PublicationHeaderWidget(publication),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            child: _ArticleTitleWidget(
              title: publication.titleHtml,
              renderType: renderType,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 18, 8, 0),
            child: PublicationStatsWidget(publication),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
            child: PublicationHubsWidget(hubs: publication.hubs),
          ),
          if (publication.format != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: PublicationFormatWidget(publication.format!),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (publication.leadData.image.isNotEmpty)
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
                        imageUrl: publication.leadData.image.url,
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
                    p.feedConfig.isImageVisible != c.feedConfig.isImageVisible,
                builder: (context, state) {
                  if (!state.feedConfig.isDescriptionVisible) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
                    child: HtmlWidget(
                      publication.leadData.textHtml,
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
          ArticleFooterWidget(publication: publication),
        ],
      ),
    );
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
