import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../config/constants.dart';
import '../../model/render_type.dart';

class CardTitleWidget extends StatelessWidget {
  const CardTitleWidget({
    Key? key,
    required this.title,
    required this.renderType,
    this.onPressed,
  }) : super(key: key);

  final String title;
  final RenderType renderType;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(kBorderRadiusDefault),
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
