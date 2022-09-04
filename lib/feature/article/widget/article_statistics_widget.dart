import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../common/model/extension/num_x.dart';
import '../../../common/model/stat_type.dart';
import '../../../config/constants.dart';
import '../../comment/page/comment_list_page.dart';
import '../model/article_statistics_model.dart';

class ArticleStatisticsWidget extends StatelessWidget {
  const ArticleStatisticsWidget({
    Key? key,
    required this.articleId,
    required this.statistics,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) : super(key: key);

  final String articleId;
  final ArticleStatisticsModel statistics;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        IconText(
          icon: Icons.insert_chart_rounded,
          text: statistics.score.compact(),
          color: statistics.score >= 0
              ? StatType.score.color
              : StatType.score.negativeColor,
        ),
        IconText(
          icon: Icons.chat_bubble_rounded,
          text: statistics.commentsCount.compact(),
          onTap: () => context.router.pushWidget(
            CommentListPage(articleId: articleId),
          ),
        ),
        IconText(
          icon: Icons.bookmark_rounded,
          text: statistics.favoritesCount.compact(),
        ),
        IconText(
          icon: Icons.remove_red_eye_rounded,
          text: statistics.readingCount.compact(),
        ),
      ],
    );
  }
}

class IconText extends StatelessWidget {
  const IconText({
    Key? key,
    required this.icon,
    required this.text,
    this.color,
    this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Color? color;
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
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 6),
              Text(
                text,
                style: Theme.of(context).textTheme.caption?.copyWith(
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
