import 'package:flutter/material.dart';

import '../common/model/stat_type.dart';
import 'stat_text_widget.dart';

class ProfileStatWidget extends StatelessWidget {
  const ProfileStatWidget({
    Key? key,
    this.type = StatType.neutral,
    required this.title,
    required this.value,
  }) : super(key: key);

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
          style: Theme.of(context).textTheme.headline6,
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
