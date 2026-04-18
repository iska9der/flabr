import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../data/model/render_type_enum.dart';
import '../extension/extension.dart';
import '../theme/theme.dart';

class CardTitleWidget extends StatelessWidget {
  const CardTitleWidget({
    super.key,
    required this.title,
    required this.renderType,
    this.onPressed,
  });

  final String title;
  final RenderType renderType;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textStyle = theme.textTheme.titleLarge;

    return InkWell(
      borderRadius: AppStyles.cardBorderRadius,
      onTap: onPressed,
      child: switch (renderType == .plain) {
        true => Text(title, style: textStyle),
        false => HtmlWidget(
          title,
          textStyle: TextStyle(
            color: textStyle?.color,
            fontSize: textStyle?.fontSize,
          ),
        ),
      },
    );
  }
}
