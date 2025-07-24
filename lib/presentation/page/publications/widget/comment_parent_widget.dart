import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart';

import '../../../../data/model/comment_base.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/html_view_widget.dart';

class CommentParent extends StatefulWidget {
  const CommentParent({super.key, required this.parent, this.onParentTapped});

  final CommentBase parent;
  final VoidCallback? onParentTapped;

  @override
  State<CommentParent> createState() => _CommentParentState();
}

class _CommentParentState extends State<CommentParent> {
  final tag = UniqueKey();

  late TextStyle textStyle = DefaultTextStyle.of(context).style;
  late Color bgColor = context.theme.colors.cardHighlight;
  late final parentHtml = HtmlView(
    textHtml: widget.parent.message,
    textStyle: textStyle,
    renderMode: RenderMode.column,
    padding: EdgeInsets.zero,
  );

  @override
  void didChangeDependencies() {
    bgColor = context.theme.colors.cardHighlight;
    textStyle = DefaultTextStyle.of(context).style;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final text = parse(widget.parent.message).documentElement?.text ?? '';
    if (text.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Hero(
        tag: tag,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppStyles.cardBorderRadius,
            color: bgColor,
          ),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 100),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 2),
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        GestureDetector(
                          onTap: widget.onParentTapped,
                          behavior: HitTestBehavior.translucent,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 8),
                            child: Row(
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  size: 18,
                                  color: context.theme.colors.primary,
                                ),
                                Expanded(
                                  child: SelectableText.rich(
                                    TextSpan(
                                      text: 'ответил на ',
                                      style: textStyle,
                                      children: [
                                        TextSpan(
                                          text: 'сообщение от wew ew ',
                                          style: textStyle.copyWith(
                                            color: context.theme.colors.primary,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: widget.parent.author.alias,
                                              style: textStyle.copyWith(
                                                color:
                                                    context
                                                        .theme
                                                        .colors
                                                        .primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const TextSpan(text: ':'),
                                      ],
                                    ),
                                    onTap: widget.onParentTapped,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        parentHtml,
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                top: 60,
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: AppStyles.cardBorderRadius,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          bgColor.withValues(alpha: .1),
                          bgColor.withValues(alpha: .3),
                          bgColor.withValues(alpha: .6),
                          bgColor.withValues(alpha: .9),
                          bgColor,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton.filled(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(Icons.remove_red_eye_sharp, size: 16),
                  tooltip: 'Показать полностью',
                  onPressed:
                      () => context.buildModalRoute(
                        rootNavigator: true,
                        child: Hero(
                          tag: tag,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: AppStyles.cardBorderRadius,
                              color: bgColor,
                            ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: parentHtml,
                            ),
                          ),
                        ),
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
