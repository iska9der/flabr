import 'package:flutter/material.dart';

import '../../../data/model/comment_base.dart';
import '../../../data/model/stat_type_enum.dart';
import '../stat_text_widget.dart';

class CommentRatingWidget extends StatelessWidget {
  const CommentRatingWidget(this.comment, {super.key});

  final CommentBase comment;

  @override
  Widget build(BuildContext context) {
    const type = StatType.score;

    return Row(
      children: [
        Icon(
          Icons.insert_chart_rounded,
          color: comment.score >= 0 ? type.color : type.negativeColor,
        ),
        const SizedBox(width: 6),
        StatTextWidget(
          type: type,
          value: comment.score,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
