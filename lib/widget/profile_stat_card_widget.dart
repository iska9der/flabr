import 'package:flutter/material.dart';

import '../common/model/stat_type.dart';
import 'card_widget.dart';

class ProfileStatCardWidget extends StatelessWidget {
  const ProfileStatCardWidget({
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

    return Expanded(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          FlabrCard(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline5?.copyWith(
                    color: color,
                  ),
            ),
          ),
          Align(
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
