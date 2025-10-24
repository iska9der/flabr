import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../bloc/settings/settings_cubit.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/render_type_enum.dart';
import '../../../../../di/di.dart';
import '../../../../../feature/image_action/image_action.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/enhancement/enhancement.dart';
import '../stats/publication_stats_widget.dart';
import 'card_html_widget.dart';
import 'components/footer_widget.dart';
import 'components/header_widget.dart';
import 'components/hubs_widget.dart';
import 'components/publication_label_list.dart';
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
      onTap: () => getIt<AppRouter>().push(
        PublicationFlowRoute(
          type: publication.type.name,
          id: publication.id,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                if (showType) PublicationTypeWidget(type: publication.type),
                PublicationHeaderWidget(publication),
                _ArticleTitleWidget(
                  title: publication.titleHtml,
                  renderType: renderType,
                ),
                PublicationStatsWidget(publication),
                PublicationHubsWidget(hubs: publication.hubs),
                PublicationLabelList(
                  postLabels: publication.postLabels,
                  format: publication.format,
                ),
                const SizedBox(),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!publication.leadData.image.isEmpty)
                BlocBuilder<SettingsCubit, SettingsState>(
                  buildWhen: (p, c) =>
                      p.feed.isImageVisible != c.feed.isImageVisible,
                  builder: (context, state) {
                    if (!state.feed.isImageVisible) {
                      return const SizedBox();
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: NetworkImageWidget(
                        imageUrl: publication.leadData.image.url,
                        isTapable: true,
                        height: AppDimensions.imageHeight,
                      ),
                    );
                  },
                ),
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.feed.isDescriptionVisible !=
                        current.feed.isDescriptionVisible ||
                    previous.feed.isImageVisible != current.feed.isImageVisible,
                builder: (context, state) {
                  if (!state.feed.isDescriptionVisible) {
                    return const SizedBox();
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: CardHtmlWidget(
                      textHtml: publication.leadData.textHtml,
                      rebuildTriggers: [state.feed],
                      isImageVisible: state.feed.isImageVisible,
                    ),
                  );
                },
              ),
            ],
          ),
          PublicationFooterWidget(publication: publication),
        ],
      ),
    );
  }
}

class _ArticleTitleWidget extends StatelessWidget {
  const _ArticleTitleWidget({required this.title, required this.renderType});

  final String title;
  final RenderType renderType;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return switch (renderType) {
      RenderType.plain => Text(title, style: textTheme.titleLarge),
      RenderType.html => HtmlWidget(
        title,

        /// Не знаю почему сделал применение стилей таким образом,
        /// а не как выше. Как-нибудь проверить
        textStyle: TextStyle(
          fontFamily: textTheme.titleLarge?.fontFamily,
          color: textTheme.titleLarge?.color,
          fontSize: textTheme.titleLarge?.fontSize,
        ),
      ),
    };
  }
}
