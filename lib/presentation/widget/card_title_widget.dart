import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../data/model/render_type_enum.dart';
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
    return InkWell(
      borderRadius: AppStyles.borderRadius,
      onTap: onPressed,
      child: renderType == RenderType.plain
          ? Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            )
          : HtmlWidget(
              title,
              textStyle: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              ),
            ),
    );
  }
}
