import 'package:flutter/material.dart';

import '../../../../../../data/model/publication/publication.dart';
import '../../../../../extension/extension.dart';

class PublicationTypeWidget extends StatelessWidget {
  const PublicationTypeWidget({super.key, required this.type, this.color});

  final PublicationType type;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final finalColor =
        color ??
        switch (type) {
          PublicationType.news => context.theme.colors.apple,
          PublicationType.article => context.theme.colors.portage,
          PublicationType.post => context.theme.colors.scarlet,
          _ => null,
        };

    return Text(
      type.label.toUpperCase(),
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: finalColor),
    );
  }
}
