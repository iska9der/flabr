import 'package:flutter/material.dart';

import '../common/model/stat_type.dart';

class ProfileStatWidget extends StatelessWidget {
  const ProfileStatWidget({
    Key? key,
    this.type = StatType.neutral,
    required this.title,
    required this.text,
    this.isNegative = false,
  }) : super(key: key);

  final StatType type;
  final String title;
  final String text;
  final bool isNegative;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text,
          style: Theme.of(context).textTheme.headline6?.copyWith(
                color: isNegative ? type.negativeColor : type.color,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }
}
