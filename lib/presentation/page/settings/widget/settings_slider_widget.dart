import 'package:flutter/material.dart';

import '../../../extension/extension.dart';

class SettingsSliderWidget extends StatelessWidget {
  const SettingsSliderWidget({
    super.key,
    required this.label,
    this.icon,
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
  final IconData? icon;
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
    final valueLabel = valueFormatter(value);

    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: .w600,
                ),
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: .circular(999),
              ),
              child: Padding(
                padding: const .symmetric(horizontal: 11, vertical: 6),
                child: Text(
                  valueLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: .w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          label: sliderLabel ?? valueLabel,
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
        Padding(
          padding: const .symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                valueFormatter(min),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
              Text(
                valueFormatter(max),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
