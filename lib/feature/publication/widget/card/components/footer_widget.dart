import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../../data/model/stat_type.dart';
import '../../../../../presentation/extension/part.dart';
import '../../../../../presentation/utils/utils.dart';
import '../../../../auth/cubit/auth_cubit.dart';
import '../../../../auth/widget/dialog.dart';
import '../../../../summary/cubit/summary_auth_cubit.dart';
import '../../../../summary/widget/dialog.dart';
import '../../../cubit/publication_bookmark_cubit.dart';
import '../../../model/publication/publication.dart';
import '../../../model/publication_type.dart';
import '../../../page/article/article_comment_page.dart';
import '../../../page/post/post_comment_page.dart';
import '../../stats/icon_widget.dart';

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
        StatIconButton(
          icon: Icons.insert_chart_rounded,
          value: publication.statistics.score.compact(),
          isHighlighted: true,
          color: publication.statistics.score >= 0
              ? StatType.score.color
              : StatType.score.negativeColor,
        ),
        StatIconButton(
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
          StatIconButton(
            icon: Icons.auto_awesome,
            isHighlighted: true,
            onTap: () => showSummaryDialog(context, articleId: publication.id),
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
          return StatIconButton(
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
