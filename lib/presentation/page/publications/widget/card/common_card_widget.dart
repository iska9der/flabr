part of 'part.dart';

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
              spacing: 6,
              children: [
                if (showType) PublicationTypeWidget(type: publication.type),
                PublicationHeaderWidget(publication),
                _ArticleTitleWidget(
                  title: publication.titleHtml,
                  renderType: renderType,
                ),
                PublicationStatsWidget(publication),
                PublicationHubsWidget(hubs: publication.hubs),
                if (publication.format != null)
                  PublicationFormatWidget(publication.format!),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (publication.leadData.image.isNotEmpty)
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
                        height: kImageHeightDefault,
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
                    child: HtmlWidget(
                      publication.leadData.textHtml,
                      rebuildTriggers: [
                        state.feed,
                      ],
                      customWidgetBuilder: (element) {
                        if (element.localName == 'br') {
                          return SizedBox();
                        }

                        if (element.localName == 'img') {
                          if (!state.feed.isImageVisible) {
                            return const SizedBox();
                          }

                          String imgSrc = element.attributes['data-src'] ??
                              element.attributes['src'] ??
                              '';

                          if (imgSrc.isEmpty) {
                            return null;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Align(
                              child: NetworkImageWidget(
                                imageUrl: imgSrc,
                                height: kImageHeightDefault,
                                isTapable: true,
                              ),
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
          ArticleFooterWidget(
            publication: publication,
            isCard: true,
          ),
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
        )
    };
  }
}
