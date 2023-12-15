import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/model/extension/num.dart';
import '../../../common/model/stat_type.dart';
import '../../../common/utils/utils.dart';
import '../../../component/di/dependencies.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/widget/dialog.dart';
import '../../publication/cubit/publication_bookmark_cubit.dart';
import '../../publication/model/publication_type.dart';
import '../../publication/repository/publication_repository.dart';
import '../../summary/cubit/summary_auth_cubit.dart';
import '../../summary/widget/dialog.dart';
import '../model/article_model.dart';
import '../page/comment/article_comment_page.dart';
import '../page/comment/post_comment_page.dart';
import 'stats/article_stat_icon_widget.dart';

class ArticleFooterWidget extends StatelessWidget {
  const ArticleFooterWidget({
    super.key,
    required this.article,
    this.mainAxisAlignment = MainAxisAlignment.spaceAround,
  });

  final ArticleModel article;

  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        StatIconButton(
          icon: Icons.insert_chart_rounded,
          value: article.statistics.score.compact(),
          isHighlighted: true,
          color: article.statistics.score >= 0
              ? StatType.score.color
              : StatType.score.negativeColor,
        ),
        StatIconButton(
          icon: Icons.chat_bubble_rounded,
          value: article.statistics.commentsCount.compact(),
          isHighlighted: article.relatedData.unreadCommentsCount > 0,
          onTap: () => context.router.pushWidget(
            switch (article.type) {
              PublicationType.post =>
                PostCommentListPage(articleId: article.id),
              _ => ArticleCommentListPage(articleId: article.id),
            },
          ),
        ),
        _BookmarkIconButton(article: article),
        if (context.watch<SummaryAuthCubit>().state.isAuthorized)
          StatIconButton(
            icon: Icons.auto_awesome,
            isHighlighted: true,
            onTap: () => showSummaryDialog(context, articleId: article.id),
          ),
      ],
    );
  }
}

class _BookmarkIconButton extends StatelessWidget {
  const _BookmarkIconButton({required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PublicationBookmarkCubit(
        repository: getIt.get<PublicationRepository>(),
        articleId: article.id,
        isBookmarked: article.relatedData.bookmarked,
        count: article.statistics.favoritesCount,
      ),
      child: BlocConsumer<PublicationBookmarkCubit, PublicationBookmarkState>(
        listenWhen: (p, c) => c.status.isFailure,
        listener: (context, state) {
          getIt.get<Utils>().showSnack(
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
