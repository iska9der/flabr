import 'package:flutter/material.dart';

import '../../../../../../data/model/publication/publication.dart';

class PublicationTypeWidget extends StatelessWidget {
  PublicationTypeWidget({super.key, required this.type, Color? color})
    : color =
          color ??
          switch (type) {
            PublicationType.news => Colors.green.shade400,
            PublicationType.article => Colors.blueAccent,
            PublicationType.post => Colors.redAccent,
            _ => null,
          };

  final PublicationType type;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      type.label.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
    );
  }
}
