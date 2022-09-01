import 'package:flutter/material.dart';

import '../../../common/model/extension/num_x.dart';
import '../../../common/model/stat_type.dart';
import '../model/article_statistics_model.dart';

class ArticleStatisticsWidget extends StatelessWidget {
  const ArticleStatisticsWidget({
    Key? key,
    required this.statistics,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) : super(key: key);

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
  }) : super(key: key);

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
