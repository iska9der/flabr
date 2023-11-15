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
import '../cubit/bookmark_cubit.dart';
import '../model/article_model.dart';
import '../page/comment_list_page.dart';
import '../repository/article_repository.dart';
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
          text: article.statistics.score.compact(),
          isHighlighted: true,
          color: article.statistics.score >= 0
              ? StatType.score.color
              : StatType.score.negativeColor,
        ),
        StatIconButton(
          icon: Icons.chat_bubble_rounded,
          text: article.statistics.commentsCount.compact(),
          isHighlighted: article.relatedData.unreadCommentsCount > 0,
          onTap: () => context.router.pushWidget(
            CommentListPage(articleId: article.id),
          ),
        ),
        _BookmarkIconButton(article: article),
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
      create: (context) => BookmarkCubit(
        repository: getIt.get<ArticleRepository>(),
        articleId: article.id,
        isBookmarked: article.relatedData.bookmarked,
        count: article.statistics.favoritesCount,
      ),
      child: BlocConsumer<BookmarkCubit, BookmarkState>(
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
            text: state.count.compact(),
            isHighlighted: state.isBookmarked,
            isLoading: state.status.isLoading,
            onTap: () => context.read<AuthCubit>().state.isUnauthorized
                ? showLoginDialog(context)
                : context.read<BookmarkCubit>().toggle(),
          );
        },
      ),
    );
  }
}
