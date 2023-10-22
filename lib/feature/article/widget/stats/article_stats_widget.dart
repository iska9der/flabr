import 'package:flutter/material.dart';

import '../../../../common/model/extension/num.dart';
import '../../model/article_complexity.dart';
import '../../model/article_model.dart';
import 'article_stat_widget.dart';

class ArticleStatsWidget extends StatelessWidget {
  const ArticleStatsWidget(this.article, {super.key});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (article.complexity != null) _ComplexityStat(article.complexity!),
        if (article.readingTime > 0)
          ArticleStat(
            text: '${article.readingTime} мин',
            icon: Icons.access_time_filled_rounded,
          ),
        ArticleStat(
          icon: Icons.remove_red_eye_rounded,
          text: article.statistics.readingCount.compact(),
        ),
      ],
    );
  }
}

class _ComplexityStat extends StatelessWidget {
  const _ComplexityStat(this.complexity);

  final ArticleComplexity complexity;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (complexity) {
      ArticleComplexity.low => Colors.green.shade400,
      ArticleComplexity.medium => Colors.blueAccent,
      ArticleComplexity.high => Colors.redAccent,
    };

    final IconData icon = switch (complexity) {
      ArticleComplexity.low => Icons.light_mode_rounded,
      ArticleComplexity.medium => Icons.filter_drama_rounded,
      ArticleComplexity.high => Icons.thunderstorm_rounded,
    };

    return ArticleStat(text: complexity.label, icon: icon, color: color);
  }
}
