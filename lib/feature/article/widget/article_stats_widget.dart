import 'package:flutter/material.dart';

import '../../../common/model/extension/num_x.dart';
import '../model/article_complexity.dart';
import '../model/article_model.dart';

class ArticleStatsWidget extends StatelessWidget {
  const ArticleStatsWidget(this.article, {super.key});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (article.complexity != null) _ComplexityWidget(article.complexity!),
        if (article.readingTime > 0)
          _StatWidget(
            text: '${article.readingTime} мин',
            icon: Icons.access_time_filled_rounded,
          ),
        _StatWidget(
          icon: Icons.remove_red_eye_rounded,
          text: article.statistics.readingCount.compact(),
        ),
      ],
    );
  }
}

class _StatWidget extends StatelessWidget {
  const _StatWidget({
    required this.text,
    required this.icon,
    this.color,
  });

  final String text;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? Colors.grey;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: actualColor,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: actualColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}

class _ComplexityWidget extends StatelessWidget {
  const _ComplexityWidget(this.complexity);

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

    return _StatWidget(text: complexity.label, icon: icon, color: color);
  }
}
