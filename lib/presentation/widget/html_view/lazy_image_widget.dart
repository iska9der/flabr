import 'package:flutter/material.dart';

import '../../../feature/image_action/image_action.dart';
import '../../extension/context.dart';
import '../../theme/theme.dart';
import 'lazy_visibility_widget.dart';

/// Ленивый рендеринг изображения с поддержкой включения/отключения.
///
/// Если [canShow] == false, показывает интерактивную карточку
/// с кнопкой для временного отображения изображения.
class LazyImageWidget extends StatefulWidget {
  const LazyImageWidget({
    super.key,
    this.canShow = true,
    required this.imageUrl,
    this.tooltip,
    this.semanticLabel,
  });

  /// Разрешено ли показывать изображения
  /// Если false - показываем интерактивную карточку с кнопкой включить
  final bool canShow;
  final String imageUrl;
  final String? tooltip;
  final String? semanticLabel;

  @override
  State<LazyImageWidget> createState() => _LazyImageWidgetState();
}

class _LazyImageWidgetState extends State<LazyImageWidget> {
  /// Локальное состояние
  late bool _isEnabled = widget.canShow;

  @override
  void didUpdateWidget(LazyImageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    /// Если флаг canShow изменился извне (в настройках) - обновляем состояние
    if (oldWidget.canShow != widget.canShow && _isEnabled != widget.canShow) {
      setState(() => _isEnabled = widget.canShow);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = AppDimensions.imageHeight;
    final bgColor = context.theme.colorScheme.surfaceContainer;

    /// Если изображения отключены - показываем интерактивную карточку
    /// по нажатию на которую пользователь может увидеть
    /// это конкретное изображение
    if (!_isEnabled) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: Material(
          color: bgColor,
          child: InkWell(
            onTap: () => setState(() => _isEnabled = true),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 48),
                  SizedBox(height: 8),
                  Text(
                    'Отобразить изображение',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    /// Примешиваем url с хэш-кодом объекта, так как некоторые изображения
    /// переиспользуются в html-верстке, что приводит к тому,
    /// что эти изображения не загружаются
    final key = Object.hash(widget.imageUrl, identityHashCode(this));

    /// Изображения включены - показываем ленивый виджет
    return LazyVisibilityWidget(
      uniqueKey: key.toString(),
      resetKey: (_isEnabled, widget.imageUrl),
      debounceDelay: const Duration(milliseconds: 400),
      placeholder: () => SizedBox(
        height: height,
        width: double.infinity,
      ),
      content: () => _buildContent(height),
    );
  }

  Widget _buildContent(double height) {
    Widget result = Center(
      child: NetworkImageWidget(
        imageUrl: widget.imageUrl,
        height: height,
        isTapable: true,
      ),
    );

    /// Добавить семантическую метку если доступна
    if (widget.semanticLabel != null) {
      result = Semantics(
        image: true,
        label: widget.semanticLabel,
        child: result,
      );
    }

    /// Добавить подсказку (tooltip) если доступна
    if (widget.tooltip != null) {
      result = Tooltip(
        excludeFromSemantics: true,
        message: widget.tooltip,
        child: result,
      );
    }

    return result;
  }
}
