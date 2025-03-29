import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../../../../../core/component/router/app_router.dart';
import '../../../../../../core/constants/constants.dart';
import '../../../../../../data/model/publication/publication.dart';
import '../../../../../../di/di.dart';
import '../../../../../../feature/auth/auth.dart';
import '../../../../../extension/extension.dart';
import '../../../../../widget/enhancement/enhancement.dart';
import '../../../cubit/publication_bookmark_cubit.dart';
import '../../stats/publication_stat_icon_widget.dart';
import 'score_widget.dart';

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
    final isSummaryAuthorized = context.select<SummaryAuthCubit, bool>(
      (cubit) => cubit.state.isAuthorized,
    );

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        ScoreWidget(isBlocked: isVoteBlocked, publication: publication),
        PublicationStatIconButton(
          icon: Icons.chat_bubble_rounded,
          value: publication.statistics.commentsCount.compact(),
          isHighlighted: publication.relatedData.unreadCommentsCount > 0,
          onTap:
              () => context.router.push(
                PublicationFlowRoute(
                  type: publication.type.name,
                  id: publication.id,
                  children: [PublicationCommentRoute()],
                ),
              ),
        ),
        _BookmarkIconButton(
          key: Key('PublicationFooter_bookmark_${publication.id}'),
          publication: publication,
        ),
        PublicationStatIconButton(
          key: Key('PublicationFooter_summary_${publication.id}'),
          icon: Icons.auto_awesome,
          isHighlighted: isSummaryAuthorized,
          onTap: () {
            final url = '${Urls.baseUrl}/ru/articles/${publication.id}';

            showSummaryDialog(
              context,
              url: url,
              repository: getIt(),
              loaderWidget: CircleIndicator.medium(),
              onLinkPressed: (link) => getIt<AppRouter>().launchUrl(link),
            );
          },
        ),
      ],
    );
  }
}

class _BookmarkIconButton extends StatelessWidget {
  const _BookmarkIconButton({required this.publication, super.key});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => PublicationBookmarkCubit(
            repository: getIt(),
            publicationId: publication.id,
            source: PublicationSource.fromType(publication.type),
            isBookmarked: publication.relatedData.bookmarked,
            count: publication.statistics.favoritesCount,
          ),
      child: BlocConsumer<PublicationBookmarkCubit, PublicationBookmarkState>(
        listenWhen: (p, c) => c.status.isFailure,
        listener: (context, state) {
          context.showSnack(content: Text(state.error));
        },
        buildWhen: (p, c) => p.status != c.status,
        builder: (context, state) {
          return PublicationStatIconButton(
            icon: Icons.bookmark_rounded,
            value: state.count.compact(),
            isHighlighted: state.isBookmarked,
            isLoading: state.status.isLoading,
            onTap:
                () =>
                    context.read<AuthCubit>().state.isAuthorized
                        ? context.read<PublicationBookmarkCubit>().toggle()
                        : showLoginSnackBar(context),
          );
        },
      ),
    );
  }
}
