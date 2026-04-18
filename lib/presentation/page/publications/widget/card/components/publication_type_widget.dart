import 'package:flutter/material.dart';

import '../../../../../../data/model/publication/publication.dart';
import '../../../../../extension/extension.dart';

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

    return Text(
      type.label.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(color: finalColor),
    );
  }
}
