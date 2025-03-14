part of '../part.dart';

class ArticleFooterWidget extends StatelessWidget {
  const ArticleFooterWidget({
    super.key,
    required this.publication,
    this.isVoteBlocked = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
  });

  final Publication publication;
  final bool isVoteBlocked;

  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        _VoteButtonsRow(isBlocked: isVoteBlocked, publication: publication),
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
      create: (_) => PublicationBookmarkCubit(
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

class _VoteButtonsRow extends StatelessWidget {
  const _VoteButtonsRow({
    required this.publication,
    this.isBlocked = true,
  });

  final Publication publication;
  final bool isBlocked;

  buildTooltip({required Widget child}) {
    final stats = publication.statistics;

    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      showDuration: Duration(seconds: 5),
      message: 'Всего голосов ${stats.score}: '
          '↑${stats.votesCountPlus} и ↓${stats.votesCountMinus}',
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final density = VisualDensity(horizontal: -4, vertical: -4);
    final color = publication.statistics.score >= 0
        ? StatType.score.color
        : StatType.score.negativeColor;
    final iconStyle = IconButton.styleFrom(
      visualDensity: density,
      minimumSize: const Size(36, double.infinity),
    );

    return BlocSelector<AuthCubit, AuthState, bool>(
      selector: (state) => !state.isAuthorized,
      builder: (context, isUnathorized) {
        if (isBlocked ||
            isUnathorized ||
            publication.relatedData.votePlus.isVotingOver) {
          final icon = switch (publication.relatedData.vote.value) {
            != null && > 0 => Icons.arrow_upward,
            != null && < 0 => Icons.arrow_downward,
            _ => Icons.insert_chart_rounded,
          };

          return buildTooltip(
            child: PublicationStatIconButton(
              icon: icon,
              value: publication.statistics.score.compact(),
              isHighlighted: true,
              color: publication.statistics.score >= 0
                  ? StatType.score.color
                  : StatType.score.negativeColor,
            ),
          );
        }

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              style: iconStyle,
              tooltip: 'Повысить рейтинг',
              icon: Icon(Icons.arrow_upward, size: 18),
              onPressed: () => context.read<PublicationVoteBloc>().add(
                    PublicationVoteUpEvent(
                      id: publication.id,
                      vote: publication.relatedData.votePlus,
                    ),
                  ),
            ),
            buildTooltip(
              child: SizedBox(
                width: 40,
                child: Text(
                  publication.statistics.score.compact(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: color, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            IconButton(
              style: iconStyle,
              tooltip: 'Понизить рейтинг',
              icon: Icon(
                Icons.arrow_downward,
                size: 18,
                color: Theme.of(context).disabledColor,
              ),
              onPressed: () => context.read<PublicationVoteBloc>().add(
                    PublicationVoteDownEvent(
                      id: publication.id,
                      vote: publication.relatedData.voteMinus,
                    ),
                  ),
            ),
          ],
        );
      },
    );
  }
}
