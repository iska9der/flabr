import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        /// Текст
        Padding(
          padding: EdgeInsets.only(left: paddingLeft, right: basePadding),
          child: HtmlView(
            textHtml: comment.message,
            renderMode: RenderMode.column,
            padding: EdgeInsets.zero,
          ),
        ),

        /// Футер
        Padding(
          padding: const EdgeInsets.all(basePadding),
          child: Row(
            children: [
              CommentRatingWidget(comment),
              const Spacer(),
              Text(
                DateFormat.yMd().add_jm().format(comment.publishedAt),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
