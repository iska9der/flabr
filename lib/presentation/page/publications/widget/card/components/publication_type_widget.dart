import 'package:flutter/material.dart';

import '../../../../../../data/model/publication/publication.dart';

class PublicationTypeWidget extends StatelessWidget {
  const PublicationTypeWidget({super.key, required this.type, this.color});

  final PublicationType type;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final finalColor =
        color ??
        switch (type) {
          PublicationType.news => Colors.green.shade400,
          PublicationType.article => Colors.blueAccent,
          PublicationType.post => Colors.redAccent,
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
