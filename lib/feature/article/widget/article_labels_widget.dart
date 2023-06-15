import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../model/article_model.dart';

class ArticleLabelsWidget extends StatelessWidget {
  const ArticleLabelsWidget(
    this.article, {
    super.key,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        if (article.format != null)
          _LabelButton(
            text: article.format!.label,
            color: article.format!.color,
          ),
      ],
    );
  }
}

class _LabelButton extends StatelessWidget {
  const _LabelButton({
    required this.text,
    this.color,
  });

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final actualColor = color ?? Colors.blueAccent;

    return OutlinedButton(
      onPressed: null,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        minimumSize: Size.zero,
        side: BorderSide(color: actualColor),
        foregroundColor: actualColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(kBorderRadiusDefault),
          ),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          color: actualColor,
        ),
      ),
    );
  }
}
