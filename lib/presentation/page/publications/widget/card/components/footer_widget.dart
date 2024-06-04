import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/component/di/injector.dart';
import '../../../../../../core/component/router/app_router.dart';
import '../../../../../../data/model/publication/publication.dart';
import '../../../../../../data/model/publication/publication_type_enum.dart';
import '../../../../../../data/model/stat_type_enum.dart';
import '../../../../../extension/part.dart';
import '../../../../../feature/auth/cubit/auth_cubit.dart';
import '../../../../../feature/auth/widget/dialog.dart';
import '../../../../../feature/summary/cubit/summary_auth_cubit.dart';
import '../../../../../feature/summary/widget/summary_dialog.dart';
import '../../../../../utils/utils.dart';
import '../../../articles/article_comment_page.dart';
import '../../../cubit/publication_bookmark_cubit.dart';
import '../../../posts/post_comment_page.dart';
import '../../stats/publication_stat_icon_widget.dart';

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
          onTap: () => getIt<AppRouter>().pushWidget(
            switch (publication.type) {
              PublicationType.post => PostCommentListPage(id: publication.id),
              _ => ArticleCommentListPage(id: publication.id),
            },
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
