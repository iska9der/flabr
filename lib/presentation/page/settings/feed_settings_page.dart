import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../data/model/filter/filter.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../../widget/filter/filter_chip_list.dart';
import 'model/config_model.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_checkbox_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';

const double _fontHeightMin = 1;

@RoutePage()
class FeedSettingsPage extends StatelessWidget {
  const FeedSettingsPage({super.key});

  static const String routePath = 'feed';

  @override
  Widget build(BuildContext context) {
    return const FeedSettingsView();
  }
}

class FeedSettingsView extends StatelessWidget {
  const FeedSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsNestedScaffold(
      title: 'Лента',
      children: [
        SettingsSectionWidget(
          title: 'Карточки',
          children: [
            SettingsFeedWidget(),
            FeedTitleTypographyWidget(),
            FeedDescriptionTypographyWidget(),
          ],
        ),
        SettingsSectionWidget(
          title: 'Поведение',
          children: [
            SettingNavVisibilityWidget(),
          ],
        ),
      ],
    );
  }
}

class SettingsFeedWidget extends StatelessWidget {
  const SettingsFeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return SettingsCardWidget(
      child: Column(
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feed.isImageVisible,
            title: const Text('Изображения'),
            subtitle: const Text('влияет на производительность'),
            onChanged: (bool value) =>
                settingsCubit.changeFeedImageVisibility(isVisible: value),
          ),
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feed.isDescriptionVisible,
            title: const Text('Короткое описание'),
            onChanged: (bool value) =>
                settingsCubit.changeFeedDescVisibility(isVisible: value),
          ),
        ],
      ),
    );
  }
}

class FeedTitleTypographyWidget extends StatelessWidget {
  const FeedTitleTypographyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeedTextStyleTypographyWidget(
      title: 'Заголовок',
      previewText: 'Пример заголовка публикации в ленте',
      styleSelector: (state) => state.feed.titleStyle,
      defaultStyleBuilder: (context) =>
          _defaultTypography(context).feedPublicationTitle,
      previewStyleBuilder: (context) =>
          context.theme.appTypography.feedPublicationTitle,
      onStyleChange: (context, style) =>
          context.read<SettingsCubit>().changeFeedTitleStyle(style),
      fontSizeMin: 20,
      fontSizeMax: 30,
      fontHeightMax: 1.3,
    );
  }
}

class FeedDescriptionTypographyWidget extends StatelessWidget {
  const FeedDescriptionTypographyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _FeedTextStyleTypographyWidget(
      title: 'Короткое описание',
      previewText: 'Короткое описание помогает быстро понять, о чем публикация',
      styleSelector: (state) => state.feed.descriptionStyle,
      defaultStyleBuilder: (context) =>
          _defaultTypography(context).feedPublicationDescription,
      previewStyleBuilder: (context) =>
          context.theme.appTypography.feedPublicationDescription,
      onStyleChange: (context, style) =>
          context.read<SettingsCubit>().changeFeedDescriptionStyle(style),
      fontSizeMin: 12,
      fontSizeMax: 20,
      fontHeightMax: 1.5,
    );
  }
}

AppTypographyExtension _defaultTypography(BuildContext context) {
  final textTheme = AppTypography.textTheme(
    scheme: context.theme.colorScheme,
  );

  return AppTypographyExtension.fromTextTheme(textTheme);
}

class _FeedTextStyleTypographyWidget extends StatelessWidget {
  const _FeedTextStyleTypographyWidget({
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
        return _FeedTextStyleTypographyCard(
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

class _FeedTextStyleTypographyCard extends StatefulWidget {
  const _FeedTextStyleTypographyCard({
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
  State<_FeedTextStyleTypographyCard> createState() =>
      _FeedTextStyleTypographyCardState();
}

class _FeedTextStyleTypographyCardState
    extends State<_FeedTextStyleTypographyCard> {
  late double _fontSize;
  late double _fontHeight;

  @override
  void initState() {
    super.initState();

    _syncValues();
  }

  @override
  void didUpdateWidget(covariant _FeedTextStyleTypographyCard oldWidget) {
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
    setState(_syncValues);
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
          _FeedTitleSlider(
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
          _FeedTitleSlider(
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

class _FeedTitleSlider extends StatelessWidget {
  const _FeedTitleSlider({
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

class SettingNavVisibilityWidget extends StatelessWidget {
  const SettingNavVisibilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Навигация',
      child: Column(
        crossAxisAlignment: .start,
        spacing: 12,
        children: [
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.misc.navigationAlignment !=
                current.misc.navigationAlignment,
            builder: (context, state) {
              return Padding(
                padding: const .only(top: 8.0),
                child: FilterChipList(
                  options: NavigationAlignment.values
                      .map((e) => FilterOption(label: e.label, value: e.label))
                      .toList(),
                  isSelected: (option) =>
                      state.misc.navigationAlignment.label == option.label,
                  onSelected: (isSelected, option) {
                    final resolved = NavigationAlignment.values.firstWhere(
                      (element) => element.label == option.value,
                    );

                    context.read<SettingsCubit>().changeNavigationAlignment(
                      resolved,
                    );
                  },
                ),
              );
            },
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.misc.navigationOnScrollVisible !=
                current.misc.navigationOnScrollVisible,
            builder: (context, state) {
              return SettingsCheckboxWidget(
                initialValue: state.misc.navigationOnScrollVisible,
                title: const Text('Показывать при скролле'),
                onChanged: (bool value) => context
                    .read<SettingsCubit>()
                    .changeNavigationOnScrollVisibility(isVisible: value),
              );
            },
          ),
        ],
      ),
    );
  }
}
