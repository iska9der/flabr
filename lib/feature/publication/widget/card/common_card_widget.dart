import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../common/model/render_type.dart';
import '../../../../common/widget/enhancement/card.dart';
import '../../../../component/di/injector.dart';
import '../../../../component/router/app_router.dart';
import '../../../../component/theme/theme_part.dart';
import '../../../common/image/widget/network_image_widget.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../../model/publication/publication.dart';
import '../../page/article/article_detail_page.dart';
import '../stats/stats_widget.dart';
import 'components/footer_widget.dart';
import 'components/format_widget.dart';
import 'components/header_widget.dart';
import 'components/hubs_widget.dart';
import 'components/publication_type_widget.dart';

class CommonCardWidget extends StatelessWidget {
  const CommonCardWidget({
    super.key,
    required this.publication,
    this.renderType = RenderType.plain,
    this.showType = false,
  });

  final PublicationCommon publication;
  final RenderType renderType;
  final bool showType;

  @override
  Widget build(BuildContext context) {
    return FlabrCard(
      onTap: () => getIt<AppRouter>().pushWidget(
        ArticleDetailPage(id: publication.id),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showType) PublicationTypeWidget(type: publication.type),
          PublicationHeaderWidget(publication),
          _ArticleTitleWidget(
            title: publication.titleHtml,
            renderType: renderType,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: PublicationStatsWidget(publication),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: PublicationHubsWidget(hubs: publication.hubs),
          ),
          if (publication.format != null)
            PublicationFormatWidget(publication.format!),
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
                buildWhen: (previous, current) =>
                    previous.feedConfig.isDescriptionVisible !=
                        current.feedConfig.isDescriptionVisible ||
                    previous.feedConfig.isImageVisible !=
                        current.feedConfig.isImageVisible,
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
