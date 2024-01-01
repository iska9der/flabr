import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

import '../../config/constants.dart';
import '../../feature/publication/model/comment/comment_model.dart';
import '../../feature/publication/widget/comment/comment_rating_widget.dart';
import 'html_view_widget.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget(this.comment, {super.key, this.onParentTap});

  final CommentModel comment;
  final VoidCallback? onParentTap;

  @override
  Widget build(BuildContext context) {
    const basePadding = 10.0;
    final additional = comment.level == 0 ? 0 : comment.level + 6;
    final paddingLeft = basePadding + additional;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (comment.parent != null)
          GestureDetector(
            onTap: onParentTap,
            child: ParentComment(parent: comment.parent!),
          ),

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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ParentComment extends StatelessWidget {
  const ParentComment({super.key, required this.parent});

  final CommentModel parent;

  @override
  Widget build(BuildContext context) {
    final text = parse(parent.message).documentElement?.text ?? '';

    if (text.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kBorderRadiusDefault),
          color: Theme.of(context).colorScheme.onInverseSurface,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
