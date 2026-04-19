import 'package:flutter/material.dart';

import '../../data/model/stat_type_enum.dart';
import '../extension/extension.dart';
import 'stat_text_widget.dart';

class ProfileStatDetailWidget extends StatelessWidget {
  const ProfileStatDetailWidget({
    super.key,
    this.type = StatType.neutral,
    required this.title,
    required this.value,
  });

  final StatType type;
  final String title;
  final num value;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      children: [
        StatTextWidget(
          type: type,
          value: value,
          style: theme.textTheme.titleLarge,
        ),
        Text(
          title,
          style: theme.textTheme.labelMedium,
        ),
      ],
    );
  }
}
