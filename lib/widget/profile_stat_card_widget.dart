import 'package:flutter/material.dart';

import '../common/model/stat_type.dart';
import 'card_widget.dart';
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
    return Expanded(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          FlabrCard(
            padding: const EdgeInsets.all(8.0),
            child: StatTextWidget(
              type: type,
              value: value,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
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
