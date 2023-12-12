import 'package:flutter/material.dart';

import '../../../../common/model/stat_type.dart';
import '../../../../common/widget/stat_text_widget.dart';
import '../../../publication/model/comment/comment_model.dart';

class CommentRatingWidget extends StatelessWidget {
  const CommentRatingWidget(this.comment, {super.key});

  final CommentModel comment;

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
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
