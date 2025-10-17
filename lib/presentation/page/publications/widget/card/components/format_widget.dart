import 'package:flutter/material.dart';

import '../../../../../../data/model/publication/publication.dart';
import '../../../../../extension/extension.dart';
import '../../../../../theme/theme.dart';

class PublicationFormatWidget extends StatelessWidget {
  const PublicationFormatWidget(this.format, {super.key});

  final PublicationFormat format;

  @override
  Widget build(BuildContext context) {
    final formatColor = format.getColor(context.theme.colors);

    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: formatColor),
          borderRadius: AppStyles.buttonBorderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            format.label,
            style: TextStyle(fontWeight: FontWeight.w500, color: formatColor),
          ),
        ),
      ),
    );
  }
}
