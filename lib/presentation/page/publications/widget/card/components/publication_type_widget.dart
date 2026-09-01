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

    final colorResolved =
        color ??
        switch (type) {
          .news => theme.colors.apple,
          .article => theme.colors.portage,
          .post => theme.colors.scarlet,
          _ => null,
        };

    return Text(
      type.label.toUpperCase(),
      style: theme.textTheme.labelMedium?.copyWith(color: colorResolved),
    );
  }
}
