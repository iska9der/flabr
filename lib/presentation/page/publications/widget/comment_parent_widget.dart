import 'package:flutter/material.dart';
import 'package:html/parser.dart';

import '../../../../data/model/comment_base.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/html_view/html_view_widget.dart';

class CommentParent extends StatefulWidget {
  const CommentParent({super.key, required this.parent, this.onParentTapped});

  final CommentBase parent;
  final VoidCallback? onParentTapped;

  @override
  State<CommentParent> createState() => _CommentParentState();
}

class _CommentParentState extends State<CommentParent> {
  final tag = UniqueKey();

  CommentBase get parent => widget.parent;

  late TextStyle textStyle;
  late Color bgColor;

  late final parentHtml = HtmlView(
    textHtml: parent.message,
    textStyle: textStyle,
    renderMode: .column,
    padding: .zero,
  );

  @override
  void didChangeDependencies() {
    bgColor = context.theme.colors.cardHighlight;
    textStyle = DefaultTextStyle.of(context).style;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final text = parse(parent.message).documentElement?.text ?? '';
    if (text.isEmpty) {
      return const SizedBox();
    }

    final theme = context.theme;
    final decoration = BoxDecoration(
      borderRadius: AppStyles.cardBorderRadius,
      color: bgColor,
    );

    return Padding(
      padding: const .symmetric(vertical: 10, horizontal: 6),
      child: Hero(
        tag: tag,
        child: DecoratedBox(
          decoration: decoration,
          child: Stack(
            alignment: .bottomCenter,
            children: [
              ShaderMask(
                blendMode: .dstIn,
                shaderCallback: (bounds) => LinearGradient(
                  begin: .topCenter,
                  end: .bottomCenter,
                  stops: [0.0, 0.3, 0.8, 1.0],
                  colors: [
                    bgColor,
                    bgColor,
                    bgColor,
                    Colors.transparent,
                  ],
                ).createShader(bounds),
                child: ConstrainedBox(
                  constraints: const .new(maxHeight: 100),
                  child: SingleChildScrollView(
                    padding: const .fromLTRB(10, 0, 10, 2),
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      mainAxisSize: .min,
                      crossAxisAlignment: .stretch,
                      children: [
                        /// "Ответил на сообщение"
                        GestureDetector(
                          onTap: widget.onParentTapped,
                          behavior: .translucent,
                          child: Padding(
                            padding: const .only(top: 10, bottom: 8),
                            child: Row(
                              mainAxisSize: .min,
                              spacing: 4,
                              children: [
                                Icon(
                                  Icons.arrow_upward,
                                  size: 18,
                                  color: theme.colors.primary,
                                ),
                                Expanded(
                                  child: SelectableText.rich(
                                    TextSpan(
                                      text: 'ответил на ',
                                      style: textStyle,
                                      children: [
                                        TextSpan(
                                          text: 'сообщение от ',
                                          style: textStyle.copyWith(
                                            color: theme.colors.primary,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: parent.author.alias,
                                              style: textStyle.copyWith(
                                                color: context
                                                    .theme
                                                    .colors
                                                    .primary,
                                                fontWeight: .w500,
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

                        /// Родительский комментарий
                        parentHtml,
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: IconButton.filled(
                  visualDensity: .compact,
                  icon: const Icon(Icons.remove_red_eye_sharp, size: 16),
                  tooltip: 'Показать полностью',
                  onPressed: () => context.buildModalRoute(
                    rootNavigator: true,
                    child: Hero(
                      tag: tag,
                      child: DecoratedBox(
                        decoration: decoration,
                        child: SingleChildScrollView(
                          padding: const .all(16),
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
