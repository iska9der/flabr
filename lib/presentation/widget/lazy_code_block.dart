import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/github_gist.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../extension/context.dart';

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
    this.onTap,
  });

  final String text;
  final String language;
  final TextStyle textStyle;
  final Map<String, TextStyle> theme;
  final EdgeInsets padding;
  final int maxRows;
  final VoidCallback? onTap;

  @override
  State<LazyCodeBlock> createState() => _LazyCodeBlockState();
}

class _LazyCodeBlockState extends State<LazyCodeBlock>
    with AutomaticKeepAliveClientMixin {
  bool _isHighlighted = false;
  bool _showHighlighted = false;

  Widget? _cachedPlaceholder;

  // Debounce таймер для быстрого скролла
  Timer? _highlightTimer;

  @override
  bool get wantKeepAlive => _isHighlighted;

  @override
  void dispose() {
    _highlightTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(LazyCodeBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Сбрасываем кэш если изменились ключевые параметры
    if (oldWidget.text != widget.text ||
        oldWidget.maxRows != widget.maxRows ||
        oldWidget.padding != widget.padding) {
      _cachedPlaceholder = null;
      _isHighlighted = false;
      _showHighlighted = false;
    }
  }

  /// Получить или создать закэшированный placeholder
  Widget _getPlaceholder(BuildContext context) {
    final currentBrightness = context.theme.brightness;

    _cachedPlaceholder ??= _buildPlaceholder(currentBrightness);

    return _cachedPlaceholder!;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final placeholder = _getPlaceholder(context);

    // Используем Stack для плавного перехода без layout shift
    return VisibilityDetector(
      key: ValueKey('code-block-${widget.text.hashCode}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          // Placeholder всегда рендерится для сохранения layout
          Visibility(
            visible: !_showHighlighted,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: placeholder,
          ),

          // Highlighted код появляется поверх placeholder
          if (_isHighlighted)
            AnimatedOpacity(
              opacity: _showHighlighted ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: _buildHighlightedCode(
                onHighlightReady: _onHighlightReady,
              ),
            ),
        ],
      ),
    );
  }

  /// Обработка изменения видимости с debounce
  void _onVisibilityChanged(VisibilityInfo info) {
    // Блок считается видимым если более 10% в viewport
    final isVisible = info.visibleFraction > 0.1;

    if (isVisible && !_isHighlighted) {
      _highlightTimer?.cancel();

      // Подсвечиваем через 200ms, если блок всё ещё в viewport
      _highlightTimer = Timer(const Duration(milliseconds: 200), () {
        if (mounted && !_isHighlighted) {
          setState(() => _isHighlighted = true);
        }
      });
    } else if (!isVisible) {
      // Блок ушел из видимости - отменяем подсветку
      _highlightTimer?.cancel();
    }
  }

  /// Вызывается когда HighlightView завершил рендеринг
  void _onHighlightReady() {
    if (mounted && !_showHighlighted) {
      setState(() => _showHighlighted = true);
    }
  }

  /// Обычный текст без подсветки (показывается до попадания в viewport)
  Widget _buildPlaceholder(Brightness brightness) {
    final codeTheme = switch (brightness) {
      Brightness.dark => darculaTheme,
      Brightness.light => githubGistTheme,
    };
    final bgColor =
        codeTheme['root']?.backgroundColor ?? context.theme.colorScheme.surface;

    final displayText = widget.text.split('\n').take(widget.maxRows).join('\n');

    return ColoredBox(
      color: bgColor,
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

  /// Подсвеченный код (показывается после попадания в viewport)
  Widget _buildHighlightedCode({required VoidCallback onHighlightReady}) {
    return _HighlightedCodeWrapper(
      onReady: onHighlightReady,
      child: HighlightView(
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
}

/// Обертка для отслеживания готовности HighlightView
class _HighlightedCodeWrapper extends StatefulWidget {
  const _HighlightedCodeWrapper({
    required this.onReady,
    required this.child,
  });

  final VoidCallback onReady;
  final Widget child;

  @override
  State<_HighlightedCodeWrapper> createState() =>
      _HighlightedCodeWrapperState();
}

class _HighlightedCodeWrapperState extends State<_HighlightedCodeWrapper> {
  @override
  void initState() {
    super.initState();
    // Вызываем коллбэк после первого фрейма
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onReady();
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
