import 'package:flutter/material.dart';

import '../../data/model/stat_type_enum.dart';
import '../extension/extension.dart';
import '../theme/theme.dart';

class StatTextWidget extends StatelessWidget {
  const StatTextWidget({
    super.key,
    required this.type,
    required this.value,
    this.textAlign,
    this.style,
  });

  final StatType type;
  final num value;

  final TextAlign? textAlign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final AppColorsExtension colors = theme.colors;

    TextStyle? statStyle = theme.textTheme.bodyLarge;
    statStyle = statStyle?.merge(style);

    return Text(
      value.compact(),
      textAlign: textAlign,
      style: statStyle?.copyWith(
        color: type.getColorByScore(value, colors),
      ),
    );
  }
}
