import 'package:flutter/material.dart';

import '../model/article_statistics.dart';

class ArticleStatisticsWidget extends StatelessWidget {
  const ArticleStatisticsWidget({Key? key, required this.statistics})
      : super(key: key);

  final ArticleStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconText(
          icon: Icons.thumbs_up_down,
          text: statistics.score.toString(),
          color: statistics.score >= 0 ? Colors.green : Colors.red,
        ),
        IconText(
          icon: Icons.mode_comment,
          text: statistics.commentsCount.toString(),
        ),
        IconText(
          icon: Icons.bookmark_border,
          text: statistics.favoritesCount.toString(),
        ),
        IconText(
          icon: Icons.remove_red_eye,
          text: statistics.readingCount.toString(),
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
