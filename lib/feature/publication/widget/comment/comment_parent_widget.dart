import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:html/parser.dart';

import '../../../../common/model/comment.dart';
import '../../../../common/widget/html_view_widget.dart';
import '../../../../component/theme/theme_part.dart';

class ParentComment extends StatelessWidget {
  const ParentComment({super.key, required this.parent});

  final CommentBase parent;

  @override
  Widget build(BuildContext context) {
    final text = parse(parent.message).documentElement?.text ?? '';

    if (text.isEmpty) {
      return const SizedBox();
    }

    final tag = UniqueKey();
    final textStyle = DefaultTextStyle.of(context).style;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Hero(
        tag: tag,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadiusDefault),
            color: Theme.of(context).colorScheme.onInverseSurface,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                ),
                IconButton.outlined(
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.remove_red_eye_sharp,
                    size: 16,
                  ),
                  onPressed: () => Navigator.of(
                    context,
                    rootNavigator: true,
                  ).push(
                    PageRouteBuilder(
                      opaque: false,
                      barrierDismissible: true,
                      pageBuilder: (_, __, ___) => Center(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: Device.getWidth(context) * .9,
                              maxHeight: Device.getHeight(context) * .5,
                            ),
                            child: Hero(
                              tag: tag,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    kBorderRadiusDefault,
                                  ),
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onInverseSurface,
                                ),
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(16),
                                  child: HtmlView(
                                    textHtml: parent.message,
                                    textStyle: textStyle,
                                    renderMode: RenderMode.column,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
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
      ),
    );
  }
}
