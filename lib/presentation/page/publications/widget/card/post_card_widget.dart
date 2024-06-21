part of 'part.dart';

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
        PublicationRouter(
          type: PublicationType.post.name,
          id: post.id,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showType) PublicationTypeWidget(type: post.type),
          PublicationHeaderWidget(post),
          Padding(
            padding: const EdgeInsets.only(top: 18),
            child: PublicationStatsWidget(post),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: PublicationHubsWidget(hubs: post.hubs),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: HtmlWidget(
              post.textHtml,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12),
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
