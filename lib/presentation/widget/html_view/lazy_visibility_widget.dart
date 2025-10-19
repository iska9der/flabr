import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Базовый виджет для ленивого рендеринга контента при попадании в viewport
///
/// Показывает легковесный placeholder до тех пор, пока виджет не попадет в видимую область.
/// После появления в viewport запускает загрузку основного контента с debounce.
///
/// Использует двухфазную загрузку:
/// 1. `isLoaded` - контент начал загружаться
/// 2. `showContent` - контент готов к отображению (плавный fade-in)
///
/// Применяется для оптимизации рендеринга тяжелых виджетов:
/// - HighlightView (подсветка синтаксиса)
/// - WebView (встраиваемые iframe)
/// - Изображения высокого разрешения
class LazyVisibilityWidget extends StatefulWidget {
  const LazyVisibilityWidget({
    super.key,
    required this.uniqueKey,
    required this.placeholder,
    required this.content,
    this.debounceDelay = const Duration(milliseconds: 200),
    this.visibilityThreshold = 0.1,
    this.fadeInDuration = const Duration(milliseconds: 150),
    this.resetKey,
  });

  /// Уникальный ключ для VisibilityDetector (например, hashCode контента)
  final String uniqueKey;

  /// Легковесный placeholder, который показывается до загрузки контента
  final Widget Function() placeholder;

  /// Основной контент, который загружается при попадании в viewport
  ///
  /// Принимает callback, который нужно вызвать после готовности контента
  /// для плавного появления через AnimatedOpacity
  final Widget Function(VoidCallback onReady) content;

  /// Задержка перед началом загрузки контента после попадания в viewport
  ///
  /// Используется для debounce при быстром скролле:
  /// - 200ms для легких виджетов (подсветка кода)
  /// - 300-500ms для тяжелых виджетов (WebView, изображения)
  final Duration debounceDelay;

  /// Минимальная видимая доля виджета (0.0 - 1.0) для начала загрузки
  ///
  /// По умолчанию 0.1 (10%) - достаточно для старта загрузки,
  /// но не слишком агрессивно для батареи
  final double visibilityThreshold;

  /// Длительность плавного появления контента
  final Duration fadeInDuration;

  /// Ключ для сброса состояния
  ///
  /// Когда это значение меняется, состояние загрузки сбрасывается.
  /// Используется для реактивного сброса при изменении критичных параметров контента.
  ///
  /// Пример: `resetKey: (widget.text, widget.maxRows)` - сбросит состояние
  /// при изменении текста или количества строк
  final Object? resetKey;

  @override
  State<LazyVisibilityWidget> createState() => _LazyVisibilityWidgetState();
}

class _LazyVisibilityWidgetState extends State<LazyVisibilityWidget>
    with AutomaticKeepAliveClientMixin {
  /// Контент начал загружаться
  bool _isLoaded = false;

  /// Контент готов к отображению
  bool _showContent = false;

  /// Debounce таймер для оптимизации при быстром скролле
  Timer? _loadTimer;

  /// Последний resetKey для отслеживания изменений
  Object? _lastResetKey;

  @override
  bool get wantKeepAlive => _isLoaded;

  @override
  void dispose() {
    _loadTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(LazyVisibilityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Сбрасываем состояние если resetKey изменился
    if (widget.resetKey != _lastResetKey) {
      setState(() {
        _isLoaded = false;
        _showContent = false;
      });
      _loadTimer?.cancel();
      _lastResetKey = widget.resetKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return VisibilityDetector(
      key: ValueKey('lazy-${widget.uniqueKey}'),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          // Placeholder всегда рендерится для сохранения layout
          Visibility(
            visible: !_showContent,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: widget.placeholder(),
          ),

          // Контент появляется поверх placeholder с плавным fade-in
          if (_isLoaded)
            AnimatedOpacity(
              opacity: _showContent ? 1.0 : 0.0,
              duration: widget.fadeInDuration,
              child: _ContentWrapper(
                onReady: _onContentReady,
                child: widget.content(_onContentReady),
              ),
            ),
        ],
      ),
    );
  }

  /// Обработка изменения видимости с debounce
  void _onVisibilityChanged(VisibilityInfo info) {
    final isVisible = info.visibleFraction > widget.visibilityThreshold;

    if (isVisible && !_isLoaded) {
      _loadTimer?.cancel();

      // Загружаем контент через debounce delay
      _loadTimer = Timer(widget.debounceDelay, () {
        if (mounted && !_isLoaded) {
          setState(() => _isLoaded = true);
        }
      });
    } else if (!isVisible) {
      // Виджет ушел из видимости - отменяем загрузку
      _loadTimer?.cancel();
    }
  }

  /// Вызывается когда контент завершил рендеринг и готов к показу
  void _onContentReady() {
    if (mounted && !_showContent) {
      setState(() => _showContent = true);
    }
  }
}

/// Обертка для отслеживания готовности контента
///
/// Вызывает onReady после первого фрейма рендеринга child-виджета
class _ContentWrapper extends StatefulWidget {
  const _ContentWrapper({
    required this.onReady,
    required this.child,
  });

  final VoidCallback onReady;
  final Widget child;

  @override
  State<_ContentWrapper> createState() => _ContentWrapperState();
}

class _ContentWrapperState extends State<_ContentWrapper> {
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
