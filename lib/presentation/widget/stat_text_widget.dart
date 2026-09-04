import 'package:flutter/material.dart';

import '../extension/extension.dart';

class StatTextWidget extends StatelessWidget {
  const StatTextWidget({
    super.key,
    required this.value,
    this.textAlign,
    this.style,
  });

  final String value;

  final TextAlign? textAlign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    TextStyle? statStyle = theme.textTheme.bodyLarge;
    statStyle = statStyle?.merge(style);

    return Text(
      value,
      textAlign: textAlign,
      style: statStyle,
    );
  }
}
