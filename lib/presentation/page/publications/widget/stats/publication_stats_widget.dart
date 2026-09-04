import 'package:flutter/material.dart';

import '../../../../../data/model/publication/publication.dart';
import '../../../../../i18n/i18n.dart';
import '../../../../extension/extension.dart';
import '../card/components/publication_type_widget.dart';
import 'publication_stat_widget.dart';

class PublicationStatsWidget extends StatelessWidget {
  const PublicationStatsWidget(
    this.publication, {
    super.key,
    this.showType = false,
  });

  final Publication publication;
  final bool showType;

  @override
  Widget build(BuildContext context) {
    return switch (publication.type) {
      PublicationType.article || PublicationType.news => CommonStatsWidget(
        type: showType ? publication.type : null,
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

class CommonStatsWidget extends StatelessWidget {
  const CommonStatsWidget({
    super.key,
    this.type,
    this.complexity,
    this.readingCount = 0,
    this.readingTime = 0,
  });

  final PublicationType? type;
  final PublicationComplexity? complexity;
  final int readingTime;
  final int readingCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      crossAxisAlignment: .center,
      children: [
        if (type != null) PublicationTypeWidget(type: type!),
        if (complexity != null) _ComplexityStat(complexity!),
        if (readingTime > 0)
          PublicationStat(
            text: context.t.publication.readingTimeMinutes(
              readingTime: readingTime,
            ),
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
    final theme = context.theme;

    final Color color = switch (complexity) {
      .low => theme.colors.complexityLow,
      .medium => theme.colors.complexityMedium,
      .high => theme.colors.complexityHigh,
    };

    final IconData icon = switch (complexity) {
      .low => Icons.light_mode_rounded,
      .medium => Icons.filter_drama_rounded,
      .high => Icons.thunderstorm_rounded,
    };

    return PublicationStat(
      text: complexity.label,
      textColor: color,
      icon: icon,
      iconColor: color,
    );
  }
}
