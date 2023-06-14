import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/num_x.dart';
import '../../../common/model/extension/state_status_x.dart';
import '../../../common/model/stat_type.dart';
import '../../../common/utils/utils.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/progress_indicator.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/widget/dialog.dart';
import '../../comment/page/comment_list_page.dart';
import '../cubit/bookmark_cubit.dart';
import '../model/article_model.dart';
import '../repository/article_repository.dart';

class ArticleStatisticsWidget extends StatelessWidget {
  const ArticleStatisticsWidget({
    super.key,
    required this.article,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
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
        StatIconButton(
          icon: Icons.remove_red_eye_rounded,
          text: article.statistics.readingCount.compact(),
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
      create: (context) => BookmarkCubit(
        service: getIt.get<ArticleRepository>(),
        articleId: article.id,
        isBookmarked: article.relatedData.bookmarked,
        count: article.statistics.favoritesCount,
      ),
      child: BlocConsumer<BookmarkCubit, BookmarkState>(
        listenWhen: (p, c) => c.status.isFailure,
        listener: (context, state) {
          getIt.get<Utils>().showNotification(
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

class StatIconButton extends StatelessWidget {
  const StatIconButton({
    super.key,
    required this.icon,
    required this.text,
    this.color,
    this.isHighlighted = false,
    this.isLoading = false,
    this.onTap,
  });

  final IconData icon;
  final String text;
  final Color? color;
  final bool isHighlighted;
  final bool isLoading;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kBorderRadiusDefault),
        child: Padding(
          padding: const EdgeInsets.all(kScreenHPadding),
          child: Row(
            children: [
              isLoading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircleIndicator.small(),
                    )
                  : Icon(
                      icon,
                      size: 14,
                      color: color?.withOpacity(isHighlighted ? 1 : .3) ??
                          Theme.of(context)
                              .iconTheme
                              .color
                              ?.withOpacity(isHighlighted ? 1 : .3),
                    ),
              const SizedBox(width: 6),
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
