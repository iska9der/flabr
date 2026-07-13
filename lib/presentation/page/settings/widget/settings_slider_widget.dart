import 'package:flutter/material.dart';

import '../../../extension/extension.dart';

class SettingsSliderWidget extends StatelessWidget {
  const SettingsSliderWidget({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueFormatter,
    required this.onChanged,
    required this.onChangeEnd,
    this.sliderLabel,
  });

  final String label;
  final double value;
  final double min;
  final double max;

  /// Количество фиксированных шагов между min и max
  final int divisions;

  /// Форматирует текущее значение рядом с названием настройки
  final String Function(double value) valueFormatter;

  /// Обновляет локальное значение во время перемещения слайдера
  final ValueChanged<double> onChanged;

  /// Сохраняет итоговое значение после завершения перемещения
  final ValueChanged<double> onChangeEnd;

  final String? sliderLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        Padding(
          padding: const .only(left: 16.0, right: 16.0, top: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                valueFormatter(value),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Slider(
          label: sliderLabel ?? label,
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}
