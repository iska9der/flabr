import 'package:flutter/material.dart';

import '../../../data/model/comment_base.dart';
import '../../../data/model/stat_type_enum.dart';
import '../../extension/extension.dart';
import '../stat_text_widget.dart';

class CommentRatingWidget extends StatelessWidget {
  const CommentRatingWidget(this.comment, {super.key});

  final CommentBase comment;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    const type = StatType.score;
    final value = comment.score;
    final foregroundColor = type.getColorByScore(value, theme.colors);

    return Row(
      children: [
        Icon(Icons.insert_chart_rounded, color: foregroundColor),
        const SizedBox(width: 6),
        StatTextWidget(
          value: value.compact(),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: foregroundColor,
          ),
        ),
      ],
    );
  }
}
