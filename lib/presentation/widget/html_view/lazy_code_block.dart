import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

import 'lazy_visibility_widget.dart';

/// Ленивый рендеринг блока кода с подсветкой синтаксиса
///
/// Показывает обычный текст до тех пор, пока блок не попадет в viewport.
/// После видимости начинает подсвечивать синтаксис.
class LazyCodeBlock extends StatefulWidget {
  const LazyCodeBlock({
    super.key,
    required this.text,
    required this.language,
    required this.textStyle,
    required this.theme,
    required this.padding,
    required this.maxRows,
    this.backgroundColor,
    this.onTap,
  });

  final String text;
  final String language;
  final TextStyle textStyle;
  final Map<String, TextStyle> theme;
  final EdgeInsets padding;
  final int maxRows;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  @override
  State<LazyCodeBlock> createState() => _LazyCodeBlockState();
}

class _LazyCodeBlockState extends State<LazyCodeBlock> {
  Widget? _cachedPlaceholder;

  @override
  void didUpdateWidget(LazyCodeBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Сбрасываем кэш если изменились ключевые параметры
    if (oldWidget.text != widget.text ||
        oldWidget.maxRows != widget.maxRows ||
        oldWidget.padding != widget.padding ||
        oldWidget.textStyle != widget.textStyle) {
      _cachedPlaceholder = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LazyVisibilityWidget(
      uniqueKey: 'code-${widget.text.hashCode}',
      // Сбрасываем загрузку при изменении критичных параметров
      resetKey: (widget.text, widget.maxRows, widget.padding),
      placeholder: () => _getPlaceholder(context),
      content: (onReady) => HighlightView(
        widget.text,
        language: widget.language,
        tabSize: 4,
        textStyle: widget.textStyle,
        maxLines: widget.maxRows,
        theme: widget.theme,
        padding: widget.padding,
        onTap: widget.onTap,
      ),
    );
  }

  /// Получить или создать закэшированный placeholder
  Widget _getPlaceholder(BuildContext context) {
    _cachedPlaceholder ??= _buildPlaceholder();

    return _cachedPlaceholder!;
  }

  /// Обычный текст без подсветки (показывается до попадания в viewport)
  Widget _buildPlaceholder() {
    final displayText = widget.text.split('\n').take(widget.maxRows).join('\n');

    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: widget.padding,
        child: Text(
          displayText,
          style: widget.textStyle,
          maxLines: widget.maxRows,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
