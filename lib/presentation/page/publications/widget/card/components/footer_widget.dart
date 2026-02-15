import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../../../../../bloc/auth/auth_cubit.dart';
import '../../../../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../../../../core/component/router/router.dart';
import '../../../../../../core/constants/constants.dart';
import '../../../../../../data/model/publication/publication.dart';
import '../../../../../../di/di.dart';
import '../../../../../extension/extension.dart';
import '../../../../../widget/dialog/dialog.dart';
import '../../../../../widget/enhancement/enhancement.dart';
import '../../stats/publication_stat_icon_widget.dart';
import 'score_widget.dart';

class PublicationFooterWidget extends StatelessWidget {
  const PublicationFooterWidget({
    super.key,
    required this.publication,
    this.isVoteBlocked = true,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  final Publication publication;
  final bool isVoteBlocked;

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final isSummaryAuthorized = context.select<SummaryAuthCubit, bool>(
      (cubit) => cubit.state.isAuthorized,
    );

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        ScoreWidget(
          isBlocked: isVoteBlocked,
          publication: publication,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
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
        PublicationStatIconButton(
          icon: Icons.auto_awesome,
          isHighlighted: isSummaryAuthorized,
          onTap: () {
            final url = '${Urls.baseUrl}/ru/articles/${publication.id}';

            showSummaryDialog(
              context,
              url: url,
              repository: getIt(),
              loaderWidget: const CircleIndicator.medium(),
              onLinkPressed: (link) => getIt<AppRouter>().launchUrl(link),
            );
          },
        ),
      ],
    );
  }
}

class _BookmarkIconButton extends StatelessWidget {
  // ignore: unused_element_parameter
  const _BookmarkIconButton({required this.publication, super.key});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    final isAuthorized = context.select<AuthCubit, bool>(
      (cubit) => cubit.state.isAuthorized,
    );

    if (!isAuthorized) {
      return PublicationStatIconButton(
        icon: Icons.bookmark_rounded,
        value: publication.statistics.favoritesCount.compact(),
        onTap: () => showLoginSnackBar(context),
      );
    }

    return BlocSelector<
      PublicationBookmarksBloc,
      PublicationBookmarksState,
      ({int count, bool isBookmarked, bool isLoading})
    >(
      selector: (state) => (
        count: state.bookmarks[publication.id]?.count ?? 0,
        isBookmarked: state.bookmarks[publication.id]?.isBookmarked ?? false,
        isLoading: state.loadingIds.contains(publication.id),
      ),
      builder: (context, data) {
        final (:count, :isBookmarked, :isLoading) = data;

        return PublicationStatIconButton(
          icon: Icons.bookmark_rounded,
          value: count.compact(),
          isHighlighted: isBookmarked,
          isLoading: isLoading,
          onTap: isLoading
              ? () => context.showSnack(
                  content: const Text('Загрузка...'),
                  duration: const Duration(seconds: 1),
                )
              : () => context.read<PublicationBookmarksBloc>().add(
                  PublicationBookmarksEvent.toggled(
                    publicationId: publication.id,
                    source: PublicationSource.fromType(publication.type),
                  ),
                ),
        );
      },
    );
  }
}
