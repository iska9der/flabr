import 'dart:async';

import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' show highlight, Node;

import 'flutter_highlight_background.dart';

export 'flutter_highlight_background.dart';

/// Highlight Flutter Widget
class HighlightView extends StatefulWidget {
  /// The original code to be highlighted
  final String source;

  /// Highlight language
  ///
  /// It is recommended to give it a value for performance.
  /// If null, then auto detection will be enabled.
  ///
  /// [All available languages](https://github.com/pd4d10/highlight/tree/master/highlight/lib/languages)
  final String? language;

  /// Highlight theme
  ///
  /// [All available themes](https://github.com/pd4d10/highlight/blob/master/flutter_highlight/lib/themes)
  final Map<String, TextStyle> theme;

  /// Padding
  final EdgeInsetsGeometry padding;

  /// Text styles
  ///
  /// Specify text styles such as font family and font size
  final TextStyle? textStyle;

  /// Progress indicator
  ///
  /// A widget that is displayed while the [source] is being processed.
  /// This may only be used if a [HighlightBackgroundEnvironment] is available.
  final Widget? progressIndicator;

  final int? minLines;

  final int? maxLines;

  final GestureTapCallback? onTap;

  HighlightView(
    String input, {
    super.key,
    this.language,
    this.theme = const {},
    this.padding = EdgeInsets.zero,
    this.textStyle,
    int tabSize = 8, // https://github.com/flutter/flutter/issues/50087
    this.progressIndicator,
    this.minLines,
    this.maxLines,
    this.onTap,
  }) : source = input.replaceAll('\t', ' ' * tabSize);

  static const _rootKey = 'root';
  static const _defaultFontColor = Color(0xff000000);
  static const _defaultBackgroundColor = Color(0xffffffff);

  // dart:io is not available at web platform currently
  // See: https://github.com/flutter/flutter/issues/39998
  // So we just use monospace here for now
  static const _defaultFontFamily = 'monospace';

  @override
  State<HighlightView> createState() => _HighlightViewState();

  /// Renders a list of [nodes] into a list of [TextSpan]s using the given
  /// [theme].
  static List<TextSpan> render(
    List<Node> nodes,
    Map<String, TextStyle> theme,
    int? maxLines,
  ) {
    List<TextSpan> spans = [];
    var currentSpans = spans;
    List<List<TextSpan>> stack = [];

    void traverse(Node node) {
      if (node.value != null) {
        currentSpans.add(node.className == null
            ? TextSpan(text: node.value)
            : TextSpan(text: node.value, style: theme[node.className!]));
        return;
      }

      if (node.children != null) {
        List<TextSpan> tmp = [];
        currentSpans
            .add(TextSpan(children: tmp, style: theme[node.className!]));
        stack.add(currentSpans);
        currentSpans = tmp;

        for (var n in node.children!) {
          traverse(n);
          if (n == node.children!.last) {
            currentSpans = stack.isEmpty ? spans : stack.removeLast();
          }
        }
        return;
      }
    }

    for (var node in nodes) {
      /// If maxLines is set, we need to check if we have reached the limit
      /// and break the loop if we have.
      if (maxLines != null) {
        final strings =
            spans.map((s) => s.toPlainText(includePlaceholders: false)).join();
        final matches = '\n'.allMatches(strings).length;
        if (matches >= maxLines) {
          break;
        }
      }
      traverse(node);
    }

    return spans;
  }
}

class _HighlightViewState extends State<HighlightView> {
  late Future<List<Node>> _nodesFuture;
  late Future<List<TextSpan>> _spansFuture;

  void _parse(HighlightBackgroundProvider? backgroundProvider) {
    if (backgroundProvider == null) {
      _nodesFuture = Future.value(
        highlight.parse(widget.source, language: widget.language).nodes ?? [],
      );
      return;
    }

    _nodesFuture = backgroundProvider.parse(
      widget.source,
      language: widget.language,
    );
  }

  void _render(HighlightBackgroundProvider? backgroundProvider) {
    _spansFuture = _nodesFuture.then((nodes) {
      if (backgroundProvider == null) {
        return Future.value(
            HighlightView.render(nodes, widget.theme, widget.maxLines));
      }

      return backgroundProvider.render(nodes, widget.theme, widget.maxLines);
    });
  }

  void _parseAndRender(HighlightBackgroundProvider? backgroundProvider) {
    if (backgroundProvider == null) {
      _parse(null);
      _render(null);
      return;
    }

    final resultFuture = backgroundProvider.parseAndRender(
      widget.source,
      widget.theme,
      language: widget.language,
    );
    _nodesFuture = resultFuture.then((result) => result.nodes);
    _spansFuture = resultFuture.then((result) => result.spans);
  }

  @override
  void didChangeDependencies() {
    final backgroundProvider = HighlightBackgroundProvider.maybeOf(context);
    _parseAndRender(backgroundProvider);

    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(HighlightView oldWidget) {
    if (widget.source != oldWidget.source ||
        widget.language != oldWidget.language) {
      final backgroundProvider = HighlightBackgroundProvider.maybeOf(context);
      _parseAndRender(backgroundProvider);
    } else if (widget.theme != oldWidget.theme) {
      final backgroundProvider = HighlightBackgroundProvider.maybeOf(context);
      _render(backgroundProvider);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontFamily: HighlightView._defaultFontFamily,
      color: widget.theme[HighlightView._rootKey]?.color ??
          HighlightView._defaultFontColor,
    );
    if (widget.textStyle != null) {
      textStyle = textStyle.merge(widget.textStyle);
    }

    final bgColor = widget.theme[HighlightView._rootKey]?.backgroundColor ??
        HighlightView._defaultBackgroundColor;

    return ColoredBox(
      color: bgColor,
      child: Padding(
        padding: widget.padding,
        child: FutureBuilder<List<TextSpan>>(
          future: _spansFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              final progressIndicator = widget.progressIndicator;
              if (progressIndicator == null) {
                return const SizedBox.shrink();
              }

              assert(
                HighlightBackgroundProvider.maybeOf(context) != null,
                'Cannot display a progress indicator unless a HighlightBackgroundEnvironment is available!',
              );
              return progressIndicator;
            }

            return SelectableText.rich(
              TextSpan(
                style: textStyle,
                children: snapshot.requireData,
              ),
              // minLines: widget.minLines,
              // maxLines: widget.maxLines,
              onTap: widget.onTap,
            );
          },
        ),
      ),
    );
  }
}
