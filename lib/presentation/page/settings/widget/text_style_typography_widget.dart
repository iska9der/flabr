import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/settings/settings_cubit.dart';
import '../../../extension/extension.dart';
import '../model/config_model.dart';
import 'settings_card_widget.dart';

class TextStyleTypographyWidget extends StatelessWidget {
  const TextStyleTypographyWidget({
    super.key,
    required this.title,
    required this.previewText,
    required this.styleSelector,
    required this.defaultStyleBuilder,
    required this.previewStyleBuilder,
    required this.onStyleChange,
    required this.fontSizeMin,
    required this.fontSizeMax,
    required this.fontHeightMax,
  });

  final String title;
  final String previewText;

  /// Достает сохраненные настройки стиля из состояния
  final AppTextStyle? Function(SettingsState state) styleSelector;

  /// Стиль без пользовательских настроек, используется для fallback и сброса
  final TextStyle Function(BuildContext context) defaultStyleBuilder;

  /// Стиль из текущей темы с уже примененными пользовательскими настройками
  final TextStyle Function(BuildContext context) previewStyleBuilder;

  /// Сохраняет новые настройки стиля; null сбрасывает их к значениям темы
  final void Function(BuildContext context, AppTextStyle? style) onStyleChange;

  /// Минимальный размер шрифта для слайдера
  final double fontSizeMin;

  /// Максимальный размер шрифта для слайдера
  final double fontSizeMax;

  /// Максимальный межстрочный интервал для слайдера
  final double fontHeightMax;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = defaultStyleBuilder(context);
    final previewStyle = previewStyleBuilder(context);

    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          styleSelector(previous) != styleSelector(current),
      builder: (context, state) {
        return _TextStyleTypographyCard(
          title: title,
          previewText: previewText,
          textStyle: styleSelector(state),
          defaultStyle: defaultStyle,
          previewStyle: previewStyle,
          onStyleChange: onStyleChange,
          fontSizeMin: fontSizeMin,
          fontSizeMax: fontSizeMax,
          fontHeightMax: fontHeightMax,
        );
      },
    );
  }
}

class _TextStyleTypographyCard extends StatefulWidget {
  const _TextStyleTypographyCard({
    required this.title,
    required this.previewText,
    required this.textStyle,
    required this.defaultStyle,
    required this.previewStyle,
    required this.onStyleChange,
    required this.fontSizeMin,
    required this.fontSizeMax,
    required this.fontHeightMax,
  });

  final String title;
  final String previewText;

  /// Сохраненные пользовательские настройки; null означает значения темы
  final AppTextStyle? textStyle;

  /// Стиль без пользовательских настроек, используется для fallback и сброса
  final TextStyle defaultStyle;

  /// Стиль для preview с учетом текущей темы
  final TextStyle previewStyle;

  /// Сохраняет новые настройки стиля; null сбрасывает их к значениям темы
  final void Function(BuildContext context, AppTextStyle? style) onStyleChange;

  /// Минимальный размер шрифта для слайдера
  final double fontSizeMin;

  /// Максимальный размер шрифта для слайдера
  final double fontSizeMax;

  /// Максимальный межстрочный интервал для слайдера
  final double fontHeightMax;

  @override
  State<_TextStyleTypographyCard> createState() =>
      _TextStyleTypographyCardState();
}

class _TextStyleTypographyCardState extends State<_TextStyleTypographyCard> {
  static const double _fontHeightMin = 1;

  late double _fontSize;
  late double _fontHeight;

  @override
  void initState() {
    super.initState();

    _syncValues();
  }

  @override
  void didUpdateWidget(covariant _TextStyleTypographyCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.textStyle != widget.textStyle ||
        oldWidget.defaultStyle != widget.defaultStyle) {
      _syncValues();
    }
  }

  void _syncValues() {
    _fontSize = _clamp(
      widget.textStyle?.size ?? widget.defaultStyle.fontSize!,
      min: widget.fontSizeMin,
      max: widget.fontSizeMax,
    );
    _fontHeight = _clamp(
      widget.textStyle?.height ?? widget.defaultStyle.height!,
      min: _fontHeightMin,
      max: widget.fontHeightMax,
    );
  }

  void _reset(BuildContext context) {
    setState(() {
      _fontSize = _clamp(
        widget.defaultStyle.fontSize!,
        min: widget.fontSizeMin,
        max: widget.fontSizeMax,
      );
      _fontHeight = _clamp(
        widget.defaultStyle.height!,
        min: _fontHeightMin,
        max: widget.fontHeightMax,
      );
    });
    widget.onStyleChange(context, null);
  }

  AppTextStyle _mergeStyle(AppTextStyle style) {
    return (widget.textStyle ?? AppTextStyle.empty).merge(style);
  }

  double _clamp(
    double value, {
    required double min,
    required double max,
  }) {
    return value.clamp(min, max).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: widget.title,
      actions: [
        IconButton(
          tooltip: 'Вернуть значения по умолчанию',
          onPressed: () => _reset(context),
          icon: const Icon(Icons.restart_alt_rounded),
        ),
      ],
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        children: [
          _TextStyleSlider(
            label: 'Размер шрифта',
            value: _fontSize,
            min: widget.fontSizeMin,
            max: widget.fontSizeMax,
            divisions: (widget.fontSizeMax - widget.fontSizeMin).round(),
            valueFormatter: (value) => value.toStringAsFixed(0),
            onChanged: (value) => setState(() => _fontSize = value),
            onChangeEnd: (value) => widget.onStyleChange(
              context,
              _mergeStyle(AppTextStyle(size: value)),
            ),
          ),
          _TextStyleSlider(
            label: 'Межстрочный интервал',
            value: _fontHeight,
            min: _fontHeightMin,
            max: widget.fontHeightMax,
            divisions: ((widget.fontHeightMax - _fontHeightMin) * 20).round(),
            valueFormatter: (value) => value.toStringAsFixed(2),
            onChanged: (value) => setState(() => _fontHeight = value),
            onChangeEnd: (value) => widget.onStyleChange(
              context,
              _mergeStyle(AppTextStyle(height: value)),
            ),
          ),
          Padding(
            padding: const .symmetric(horizontal: 16.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: context.theme.colorScheme.surfaceContainer,
                borderRadius: .circular(8),
              ),
              child: Padding(
                padding: const .all(12.0),
                child: Text(
                  widget.previewText,
                  style: widget.previewStyle.copyWith(
                    fontSize: _fontSize,
                    height: _fontHeight,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _TextStyleSlider extends StatelessWidget {
  const _TextStyleSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.valueFormatter,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final String label;
  final double value;
  final double min;
  final double max;

  /// Количество фиксированных шагов между min и max.
  final int divisions;

  /// Форматирует текущее значение рядом с названием настройки.
  final String Function(double value) valueFormatter;

  /// Обновляет локальное значение во время перемещения слайдера.
  final ValueChanged<double> onChanged;

  /// Сохраняет итоговое значение после завершения перемещения.
  final ValueChanged<double> onChangeEnd;

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
          label: label,
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
