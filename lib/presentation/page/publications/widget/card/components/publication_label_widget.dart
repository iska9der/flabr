import 'package:flutter/material.dart';

import '../../../../../theme/theme.dart';

class PublicationLabelWidget extends StatelessWidget {
  const PublicationLabelWidget({
    super.key,
    required this.title,
    required this.color,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: AppStyles.buttonBorderRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Text(
          title,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
