part of 'card.dart';

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
      onTap: () => getIt<AppRouter>().navigate(
        PublicationFlowRoute(
          type: PublicationType.post.name,
          id: post.id,
        ),
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
          ArticleFooterWidget(publication: post),
        ],
      ),
    );
  }
}
