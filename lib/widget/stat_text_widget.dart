import 'package:flutter/material.dart';

import '../common/model/extension/num_x.dart';
import '../common/model/stat_type.dart';

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
    TextStyle? statStyle = Theme.of(context).textTheme.bodyLarge;

    statStyle = statStyle?.merge(style);

    return Text(
      value.compact(),
      textAlign: textAlign,
      style: statStyle?.copyWith(
        color: value < 0 ? type.negativeColor : type.color,
      ),
    );
  }
}
