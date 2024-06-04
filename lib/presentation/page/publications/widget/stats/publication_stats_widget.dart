import 'package:flutter/material.dart';

import '../../../../../data/model/publication/publication.dart';
import '../../../../../data/model/publication/publication_complexity_enum.dart';
import '../../../../../data/model/publication/publication_type_enum.dart';
import '../../../../extension/part.dart';

part 'publication_stat_widget.dart';

class PublicationStatsWidget extends StatelessWidget {
  const PublicationStatsWidget(this.publication, {super.key});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return switch (publication.type) {
      PublicationType.article ||
      PublicationType.news =>
        ArticleStatsWidget(publication as PublicationCommon),
      _ => PublicationStat(
          icon: Icons.remove_red_eye_rounded,
          text: publication.statistics.readingCount.compact(),
        ),
    };
  }
}

class ArticleStatsWidget extends StatelessWidget {
  const ArticleStatsWidget(this.article, {super.key});

  final PublicationCommon article;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (article.complexity != null) _ComplexityStat(article.complexity!),
        if (article.readingTime > 0)
          PublicationStat(
            text: '${article.readingTime} мин',
            icon: Icons.access_time_filled_rounded,
          ),
        PublicationStat(
          icon: Icons.remove_red_eye_rounded,
          text: article.statistics.readingCount.compact(),
        ),
      ],
    );
  }
}

class _ComplexityStat extends StatelessWidget {
  const _ComplexityStat(this.complexity);

  final PublicationComplexity complexity;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (complexity) {
      PublicationComplexity.low => Colors.green.shade400,
      PublicationComplexity.medium => Colors.blueAccent,
      PublicationComplexity.high => Colors.redAccent,
    };

    final IconData icon = switch (complexity) {
      PublicationComplexity.low => Icons.light_mode_rounded,
      PublicationComplexity.medium => Icons.filter_drama_rounded,
      PublicationComplexity.high => Icons.thunderstorm_rounded,
    };

    return PublicationStat(text: complexity.label, icon: icon, color: color);
  }
}
