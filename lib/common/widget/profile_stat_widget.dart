import 'package:flutter/material.dart';

import '../model/stat_type.dart';
import 'stat_text_widget.dart';

class ProfileStatWidget extends StatelessWidget {
  const ProfileStatWidget({
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
    return Column(
      children: [
        StatTextWidget(
          type: type,
          value: value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
