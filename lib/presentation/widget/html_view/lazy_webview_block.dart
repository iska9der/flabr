import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/component/router/app_router.dart';
import '../../../di/di.dart';
import '../../extension/context.dart';
import 'lazy_visibility_widget.dart';

/// Ленивый рендеринг WebView блока с поддержкой включения/отключения
///
/// Показывает placeholder до попадания в viewport.
/// После видимости инициализирует полноценный WebView.
///
/// Если [canShow] == false (WebView отключен в настройках), показывает
/// интерактивную карточку с кнопкой для временного включения WebView.
class LazyWebViewBlock extends StatefulWidget {
  const LazyWebViewBlock({
    super.key,
    required this.src,
    required this.aspectRatio,
    required this.buildWebView,
    this.canShow = true,
  });

  final String src;

  /// Залочиваем аспект соотношения сторон.
  /// Чтобы при выходе из полноэкрана (например, YouTube видео)
  /// высота WebView не расла бесконечно.
  /// AspectRatio поддерживает стабильное соотношение сторон.
  final double aspectRatio;
  final Widget Function() buildWebView;

  /// Флаг из настроек: разрешено ли показывать WebView
  /// Если false - показываем интерактивную карточку с кнопкой включить
  final bool canShow;

  @override
  State<LazyWebViewBlock> createState() => _LazyWebViewBlockState();
}

class _LazyWebViewBlockState extends State<LazyWebViewBlock> {
  /// Локальное состояние: пользователь явно включил WebView для этого элемента
  /// По умолчанию == canShow (значение из настроек)
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _isEnabled = widget.canShow;
  }

  @override
  void didUpdateWidget(LazyWebViewBlock oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Если флаг canShow изменился извне (в настройках) - обновляем состояние
    if (oldWidget.canShow != widget.canShow && _isEnabled != widget.canShow) {
      setState(() => _isEnabled = widget.canShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspectRatio = widget.aspectRatio;

    /// Если WebView отключен в настройках - показываем интерактивную карточку
    if (!_isEnabled) {
      final host = Uri.parse(widget.src).host;
      final bgColor = context.theme.colorScheme.surfaceContainer;

      return AspectRatio(
        aspectRatio: aspectRatio,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Material(
                color: bgColor,
                child: InkWell(
                  onTap: () => setState(() => _isEnabled = true),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow, size: 48),
                        const SizedBox(height: 8),
                        const Text(
                          'Отобразить WebView',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          host,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(backgroundColor: bgColor),
              onPressed: () {
                getIt<AppRouter>().launchUrl(widget.src);
              },
              child: const Text('Показать в браузере'),
            ),
          ],
        ),
      );
    }

    /// WebView включен - показываем полноценный ленивый виджет
    return LazyVisibilityWidget(
      uniqueKey: 'webview-${widget.src}',
      debounceDelay: const Duration(milliseconds: 300),
      resetKey: (widget.canShow, widget.src),
      placeholder: () => AspectRatio(
        aspectRatio: aspectRatio,
        child: Skeletonizer(
          child: ColoredBox(
            color: context.theme.colorScheme.surfaceContainer,
          ),
        ),
      ),
      content: () => AspectRatio(
        aspectRatio: aspectRatio,
        child: widget.buildWebView(),
      ),
    );
  }
}
