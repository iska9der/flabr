import 'package:flutter/material.dart';

import '../../data/model/stat_type_enum.dart';
import 'stat_text_widget.dart';

class ProfileStatCardWidget extends StatelessWidget {
  const ProfileStatCardWidget({
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
        Align(
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        StatTextWidget(
          type: type,
          value: value,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }
}
