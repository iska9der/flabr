import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/settings/settings_cubit.dart';
import '../../../../i18n/i18n.dart';
import '../../../extension/extension.dart';
import '../../../theme/constants.dart';
import '../model/config_model.dart';
import 'settings_card_widget.dart';
import 'settings_slider_widget.dart';

class TextStyleTypographyWidget extends StatelessWidget {
  const TextStyleTypographyWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.previewText,
    required this.styleSelector,
    required this.defaultStyleBuilder,
    required this.previewStyleBuilder,
    required this.onStyleChange,
    required this.fontFamilies,
    required this.fontSizeMin,
    required this.fontSizeMax,
    required this.fontHeightMax,
  });

  final String title;
  final IconData icon;
  final String previewText;

  /// Достает сохраненные настройки стиля из состояния
  final AppTextStyle? Function(SettingsState state) styleSelector;

  /// Стиль без пользовательских настроек, используется для fallback и сброса
  final TextStyle Function(BuildContext context) defaultStyleBuilder;

  /// Стиль из текущей темы с уже примененными пользовательскими настройками
  final TextStyle Function(BuildContext context) previewStyleBuilder;

  /// Сохраняет новые настройки стиля; null сбрасывает их к значениям темы
  final void Function(BuildContext context, AppTextStyle? style) onStyleChange;

  /// Доступные семейства шрифтов
  final List<String> fontFamilies;

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
          icon: icon,
          previewText: previewText,
          textStyle: styleSelector(state),
          defaultStyle: defaultStyle,
          previewStyle: previewStyle,
          onStyleChange: onStyleChange,
          fontFamilies: fontFamilies,
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
    required this.icon,
    required this.previewText,
    required this.textStyle,
    required this.defaultStyle,
    required this.previewStyle,
    required this.onStyleChange,
    required this.fontFamilies,
    required this.fontSizeMin,
    required this.fontSizeMax,
    required this.fontHeightMax,
  });

  final String title;
  final IconData icon;
  final String previewText;

  /// Сохраненные пользовательские настройки; null означает значения темы
  final AppTextStyle? textStyle;

  /// Стиль без пользовательских настроек, используется для fallback и сброса
  final TextStyle defaultStyle;

  /// Стиль для preview с учетом текущей темы
  final TextStyle previewStyle;

  /// Сохраняет новые настройки стиля; null сбрасывает их к значениям темы
  final void Function(BuildContext context, AppTextStyle? style) onStyleChange;

  /// Доступные семейства шрифтов
  final List<String> fontFamilies;

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

  late String _fontFamily;
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
    _fontFamily = _resolveFontFamily(
      widget.textStyle?.family ?? widget.defaultStyle.fontFamily,
    );
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
      _fontFamily = _resolveFontFamily(widget.defaultStyle.fontFamily);
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

  String _resolveFontFamily(String? family) {
    if (family != null && widget.fontFamilies.contains(family)) {
      return family;
    }

    return widget.fontFamilies.first;
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
    final theme = context.theme;
    final typography = context.t.settings.fonts.typography;

    return SettingsCardWidget(
      title: widget.title,
      icon: widget.icon,
      actions: [
        IconButton(
          tooltip: typography.resetDefaults,
          onPressed: () => _reset(context),
          icon: const Icon(Icons.restart_alt_rounded),
        ),
      ],
      child: Column(
        crossAxisAlignment: .stretch,
        mainAxisSize: .min,
        spacing: 20,
        children: [
          DropdownButtonFormField<String>(
            key: ValueKey(_fontFamily),
            initialValue: _fontFamily,
            decoration: InputDecoration(
              labelText: typography.font.label,
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest,
              border: theme.inputDecorationTheme.border?.copyWith(
                borderSide: .none,
              ),
            ),
            items: widget.fontFamilies
                .map(
                  (family) => DropdownMenuItem(
                    value: family,
                    child: Text(family, style: TextStyle(fontFamily: family)),
                  ),
                )
                .toList(),
            onChanged: (family) {
              if (family == null) {
                return;
              }

              setState(() => _fontFamily = family);
              widget.onStyleChange(
                context,
                _mergeStyle(AppTextStyle(family: family)),
              );
            },
          ),
          SettingsSliderWidget(
            label: typography.font.size,
            icon: Icons.format_size_rounded,
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
          SettingsSliderWidget(
            label: typography.line.height,
            icon: Icons.format_line_spacing_rounded,
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
          DecoratedBox(
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: AppRadius.xl,
            ),
            child: Padding(
              padding: const .all(16),
              child: Text(
                widget.previewText,
                style: widget.previewStyle.copyWith(
                  fontFamily: _fontFamily,
                  fontSize: _fontSize,
                  height: _fontHeight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
