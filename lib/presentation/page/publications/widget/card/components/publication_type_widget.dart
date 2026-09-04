import 'package:flutter/material.dart';

import '../../../../../../data/model/publication/publication.dart';
import '../../../../../extension/extension.dart';
import '../../stats/publication_stat_widget.dart';

class PublicationTypeWidget extends StatelessWidget {
  const PublicationTypeWidget({super.key, required this.type, this.color});

  final PublicationType type;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final finalColor =
        color ??
        switch (type) {
          PublicationType.news => theme.colors.apple,
          PublicationType.article => theme.colors.portage,
          PublicationType.post => theme.colors.scarlet,
          _ => null,
        };

    return PublicationStat(
      text: type.label,
      textColor: finalColor,
      icon: Icons.article_rounded,
      iconColor: finalColor,
    );
  }
}
