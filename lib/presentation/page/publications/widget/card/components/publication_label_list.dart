import 'package:flutter/material.dart';

import '../../../../../../data/model/publication/publication.dart';
import '../../../../../extension/extension.dart';
import 'publication_label_widget.dart';

class PublicationLabelList extends StatelessWidget {
  const PublicationLabelList({
    super.key,
    this.format,
    this.postLabels = const [],
  });

  final PublicationFormat? format;
  final List<PostLabel> postLabels;

  @override
  Widget build(BuildContext context) {
    final postLabelColor = context.theme.colors.deluge;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        if (format != null) ...[
          PublicationLabelWidget(
            color: format!.getColor(context.theme.colors),
            title: format!.label,
          ),
        ],
        ...postLabels.map(
          (label) => PublicationLabelWidget(
            title: label.title,
            color: postLabelColor,
          ),
        ),
      ].toList(),
    );
  }
}
