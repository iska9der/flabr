import 'package:flutter/material.dart';

import '../../../data/model/comment_base.dart';
import '../html_view/html_view_widget.dart';
import 'comment_rating_widget.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget(this.comment, {super.key, this.onParentTap});

  final CommentBase comment;
  final VoidCallback? onParentTap;

  @override
  Widget build(BuildContext context) {
    const basePadding = 10.0;
    final additional = comment.level == 0 ? 0 : comment.level + 6;
    final paddingLeft = basePadding + additional;

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        /// Текст
        Padding(
          padding: .only(left: paddingLeft, right: basePadding),
          child: HtmlView(
            textHtml: comment.message,
            renderMode: .column,
            padding: .zero,
          ),
        ),

        /// Футер
        Padding(
          padding: const .all(basePadding),
          child: Row(
            children: [
              CommentRatingWidget(comment),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
