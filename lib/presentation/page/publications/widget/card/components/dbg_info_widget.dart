import 'package:flutter/material.dart';

import '../../../../../../data/model/publication/publication.dart';
import '../../../../../extension/extension.dart';

class DbgInfoWidget extends StatelessWidget {
  const DbgInfoWidget(this.publication, {super.key});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return DefaultTextStyle(
      style: theme.textTheme.labelMedium!.copyWith(
        color: theme.colors.sorbus,
      ),
      child: Row(
        spacing: 4,
        children: [
          Text('id: ${publication.id}'),
          Text('type: ${publication.type.name}'),
        ],
      ),
    );
  }
}
