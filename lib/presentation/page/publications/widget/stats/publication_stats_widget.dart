part of 'part.dart';

class PublicationStatsWidget extends StatelessWidget {
  const PublicationStatsWidget(this.publication, {super.key});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return switch (publication.type) {
      PublicationType.article || PublicationType.news => ArticleStatsWidget(
          complexity: (publication as PublicationCommon).complexity,
          readingTime: (publication as PublicationCommon).readingTime,
          readingCount: publication.statistics.readingCount,
        ),
      _ => PublicationStat(
          icon: Icons.remove_red_eye_rounded,
          text: publication.statistics.readingCount.compact(),
        ),
    };
  }
}

class ArticleStatsWidget extends StatelessWidget {
  const ArticleStatsWidget({
    super.key,
    this.complexity,
    this.readingCount = 0,
    this.readingTime = 0,
  });

  final PublicationComplexity? complexity;
  final int readingTime;
  final int readingCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        if (complexity != null) _ComplexityStat(complexity!),
        if (readingTime > 0)
          PublicationStat(
            text: '$readingTime мин',
            icon: Icons.access_time_filled_rounded,
          ),
        PublicationStat(
          icon: Icons.remove_red_eye_rounded,
          text: readingCount.compact(),
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
