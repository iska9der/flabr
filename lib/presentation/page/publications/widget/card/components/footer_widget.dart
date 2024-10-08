part of '../part.dart';

class ArticleFooterWidget extends StatelessWidget {
  const ArticleFooterWidget({
    super.key,
    required this.publication,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
  });

  final Publication publication;

  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        PublicationStatIconButton(
          icon: Icons.insert_chart_rounded,
          value: publication.statistics.score.compact(),
          isHighlighted: true,
          color: publication.statistics.score >= 0
              ? StatType.score.color
              : StatType.score.negativeColor,
        ),
        PublicationStatIconButton(
          icon: Icons.chat_bubble_rounded,
          value: publication.statistics.commentsCount.compact(),
          isHighlighted: publication.relatedData.unreadCommentsCount > 0,
          onTap: () => context.router.push(
            PublicationFlowRoute(
              type: publication.type.name,
              id: publication.id,
              children: [PublicationCommentRoute()],
            ),
          ),
        ),
        _BookmarkIconButton(publication: publication),
        if (context.watch<SummaryAuthCubit>().state.isAuthorized)
          PublicationStatIconButton(
            icon: Icons.auto_awesome,
            isHighlighted: true,
            onTap: () => showSummaryDialog(
              context,
              publicationId: publication.id,
              onLinkPressed: (link) => getIt<AppRouter>().launchUrl(link),
            ),
          ),
      ],
    );
  }
}

class _BookmarkIconButton extends StatelessWidget {
  const _BookmarkIconButton({required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PublicationBookmarkCubit(
        repository: getIt(),
        articleId: publication.id,
        isBookmarked: publication.relatedData.bookmarked,
        count: publication.statistics.favoritesCount,
      ),
      child: BlocConsumer<PublicationBookmarkCubit, PublicationBookmarkState>(
        listenWhen: (p, c) => c.status.isFailure,
        listener: (context, state) {
          getIt<Utils>().showSnack(
            context: context,
            content: Text(state.error),
          );
        },
        buildWhen: (p, c) => p.status != c.status,
        builder: (context, state) {
          return PublicationStatIconButton(
            icon: Icons.bookmark_rounded,
            value: state.count.compact(),
            isHighlighted: state.isBookmarked,
            isLoading: state.status.isLoading,
            onTap: () => context.read<AuthCubit>().state.isUnauthorized
                ? showLoginDialog(context)
                : context.read<PublicationBookmarkCubit>().toggle(),
          );
        },
      ),
    );
  }
}
