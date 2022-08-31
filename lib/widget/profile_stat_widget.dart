import 'package:flutter/material.dart';

import '../common/model/stat_type.dart';

class ProfileStatWidget extends StatelessWidget {
  const ProfileStatWidget({
    Key? key,
    this.type = StatType.neutral,
    required this.title,
    required this.text,
  }) : super(key: key);

  final StatType type;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    Color? color;

    if (type == StatType.rating) {
      color = Colors.purple;
    } else if (type == StatType.score) {
      color = Colors.green;
    }

    return Column(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.headline6?.copyWith(color: color),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
