import 'dart:async';

import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Базовый виджет для ленивого рендеринга контента при попадании в viewport
///
/// Показывает легковесный placeholder до тех пор, пока виджет не попадет в видимую область.
/// После появления в viewport запускает загрузку основного контента с debounce.
///
/// Использует двухфазную загрузку для плавной анимации без layout shift:
/// - Фаза 1: Placeholder всегда рендерится (сохраняет layout)
/// - Фаза 2: Контент загружается с debounce задержкой
/// - Фаза 3: Контент появляется поверх placeholder с AnimatedOpacity (150ms)
///
/// Применяется для оптимизации рендеринга тяжелых виджетов:
/// - HighlightView (подсветка синтаксиса кода)
/// - WebView (встраиваемые iframe с видео, интерактивные элементы)
/// - Статические изображения высокого разрешения
class LazyVisibilityWidget extends StatefulWidget {
  const LazyVisibilityWidget({
    super.key,
    required this.uniqueKey,
    required this.placeholder,
    required this.content,
    this.debounceDelay = const Duration(milliseconds: 200),
    this.visibilityThreshold = 0.1,
    this.animationDuration = const Duration(milliseconds: 150),
    this.resetKey,
  });

  /// Уникальный ключ для VisibilityDetector (например, hashCode контента)
  final String uniqueKey;

  /// Легковесный placeholder, который показывается до загрузки контента
  final Widget Function() placeholder;

  /// Основной контент, который загружается при попадании в viewport
  ///
  /// Это может быть:
  /// - HighlightView для подсветки синтаксиса кода
  /// - WebView для встроенных iframe'ов
  /// - Любой другой виджет требующий оптимизации рендеринга
  ///
  /// Контент рендерится только когда элемент попадает в viewport,
  /// что обеспечивает оптимальное использование памяти и GPU.
  final Widget Function() content;

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

  /// Длительность анимации появления контента
  final Duration animationDuration;

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
  /// Флаг загрузки контента (управляет началом рендеринга)
  ///
  /// `true` - контент еще не в области видимости
  /// `false` - контент в области видимости и готов к отображению
  bool isLoading = true;

  /// Флаг готовности контента (управляет видимостью через opacity)
  bool isContentReady = false;

  /// Debounce таймер для оптимизации при быстром скролле
  ///
  /// Предотвращает ненужную загрузку контента если пользователь быстро скроллит
  /// мимо элемента, не задерживаясь на нем дольше чем `debounceDelay`.
  Timer? _loadTimer;

  /// Последний resetKey для отслеживания изменений
  ///
  /// Позволяет сбросить состояние загрузки если изменились критичные параметры
  /// контента (текст, максимум строк, размеры и т.д.)
  Object? _lastResetKey;

  @override
  bool get wantKeepAlive => !isLoading;

  @override
  void initState() {
    super.initState();
    _lastResetKey = widget.resetKey;
  }

  @override
  void dispose() {
    _loadTimer?.cancel();
    super.dispose();
  }

  /// Сбрасывает состояние загрузки если параметры контента изменились
  ///
  /// Вызывается когда изменился resetKey (например, текст кода, высота блока, размеры).
  /// Возвращает оба флага в начальное состояние:
  /// - `isLoading = true` - скрыть контент, показать только placeholder
  /// - `isContentReady = false` - отключить AnimatedOpacity анимацию
  @override
  void didUpdateWidget(LazyVisibilityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.resetKey != _lastResetKey) {
      setState(() {
        isLoading = true;
        isContentReady = false;
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
        fit: StackFit.passthrough,
        children: [
          // Placeholder всегда рендерится - это фиксирует размер Stack
          // Предотвращает layout shift когда контент появляется поверх
          widget.placeholder(),
          AnimatedOpacity(
            opacity: isContentReady ? 1.0 : 0.0,
            duration: widget.animationDuration,
            child: _ContentWrapper(
              resetKey: widget.resetKey,
              isReady: _isContentReady,
              child: widget.content(),
            ),
          ),
        ],
      ),
    );
  }

  /// Обработка изменения видимости элемента в viewport
  ///
  /// Управляет debounce таймером для оптимизации при быстром скролле:
  /// - Когда элемент входит в viewport → запускает таймер
  /// - Если таймер истек → устанавливает `isLoading = false` (контент начинает рендериться)
  /// - Если элемент покидает viewport → отменяет таймер
  ///
  /// Это предотвращает загрузку контента для элементов которые пользователь быстро скроллит,
  /// экономя память, GPU и улучшая производительность при скролле списка.
  void _onVisibilityChanged(VisibilityInfo info) {
    final isVisible = info.visibleFraction > widget.visibilityThreshold;

    if (isVisible && isLoading) {
      _loadTimer?.cancel();

      // Загружаем контент через debounce delay
      _loadTimer = Timer(widget.debounceDelay, () {
        if (mounted && isLoading) {
          setState(() => isLoading = false); // Контент начинает рендериться
        }
      });
    } else if (!isVisible) {
      // Отменяем загрузку если элемент ушел из видимости до истечения debounce
      _loadTimer?.cancel();
    }
  }

  /// Две задачи:
  /// - управление прозрачностью
  /// - проверка на готовность виджета для отображения в [_ContentWrapper]
  ///
  /// [_ContentWrapper] вызывает эту функцию при каждом обновлении виджета
  /// и переключается с SizedBox на реальный контент, если функция вернула `true`
  bool _isContentReady() {
    final isReady = mounted && !isLoading && !isContentReady;

    if (isContentReady != isReady) {
      setState(() => isContentReady = isReady);
    }

    return isReady;
  }
}

/// Реактивная обертка для ленивого рендеринга контента
///
/// Это "умная" обертка, которая не управляет состоянием сама по себе,
/// а реактивно следит за функцией `isReady()` из parent виджета.
///
/// При каждом обновлении `didUpdateWidget`:
/// 1. Вызывает функцию `widget.isReady()` через addPostFrameCallback
/// 2. Если функция вернула `true` → переключается на рендеринг реального контента
/// 3. Если функция вернула `false` → показывает SizedBox (контент не создается)
///
/// Это гарантирует, что тяжелые виджеты (HighlightView, WebView и т.д.)
/// не создаются в памяти до того момента, когда они действительно нужны.
class _ContentWrapper extends StatefulWidget {
  const _ContentWrapper({
    required this.resetKey,
    required this.isReady,
    required this.child,
  });

  /// Ключ для отслеживания сброса состояния родителем
  final Object? resetKey;

  /// Функция для проверки готовности [child] к отображению
  final ValueGetter<bool> isReady;

  final Widget child;

  @override
  State<_ContentWrapper> createState() => _ContentWrapperState();
}

class _ContentWrapperState extends State<_ContentWrapper> {
  /// Последний resetKey для отслеживания сброса состояния родителем
  Object? _lastResetKey;

  /// Локальный флаг готовности - управляет что показывать в build()
  ///
  /// Это НЕ состояние готовности само по себе, а просто отражение
  /// текущего результата функции `widget.isReady()`.
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _lastResetKey = widget.resetKey;
  }

  @override
  void didUpdateWidget(_ContentWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Если родитель сбросил состояние (resetKey изменился),
    /// сбрасываем _isReady и отслеживаем новый ключ.
    /// Это предотвращает бесконечный цикл вызванный
    /// setState в _isContentReady()
    if (widget.resetKey != _lastResetKey && _isReady) {
      setState(() => _isReady = false);
      _lastResetKey = widget.resetKey;
    }

    // Только проверяем готовность если состояние не было сброшено
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_isReady) {
        final isParentReady = widget.isReady();

        if (isParentReady) {
          setState(() => _isReady = true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Рендерим контент только когда isReady = true
    // Когда false - показываем SizedBox, так что тяжелые виджеты не создаются
    return _isReady ? widget.child : const SizedBox();
  }
}
