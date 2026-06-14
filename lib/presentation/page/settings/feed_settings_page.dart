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
      title: 'Карточки статей',
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

class FeedTitleTypographyWidget extends StatefulWidget {
  const FeedTitleTypographyWidget({super.key});

  @override
  State<FeedTitleTypographyWidget> createState() =>
      _FeedTitleTypographyWidgetState();
}

class _FeedTitleTypographyWidgetState extends State<FeedTitleTypographyWidget> {
  double? _fontSize;
  double? _fontHeight;
  FeedConfigModel? _lastFeedConfig;

  TextStyle _defaultStyle(BuildContext context) {
    final textTheme = AppTypography.textTheme(
      scheme: context.theme.colorScheme,
    );

    return AppTypographyExtension.fromTextTheme(textTheme).feedPublicationTitle;
  }

  void _syncValues(FeedConfigModel feedConfig, TextStyle defaultStyle) {
    if (_lastFeedConfig == feedConfig) {
      return;
    }

    _fontSize = feedConfig.titleStyle?.size ?? defaultStyle.fontSize;
    _fontHeight = feedConfig.titleStyle?.height ?? defaultStyle.height;
    _lastFeedConfig = feedConfig;
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = _defaultStyle(context);
    final previewStyle = context.theme.appTypography.feedPublicationTitle;

    return SettingsCardWidget(
      title: 'Заголовки',
      actions: [
        IconButton(
          tooltip: 'Вернуть значения по умолчанию',
          onPressed: () {
            setState(() {
              _fontSize = defaultStyle.fontSize;
              _fontHeight = defaultStyle.height;
              _lastFeedConfig = null;
            });
            context.read<SettingsCubit>().resetFeedTitleTypography();
          },
          icon: const Icon(Icons.restart_alt_rounded),
        ),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.feed.titleStyle != current.feed.titleStyle,
        builder: (context, state) {
          _syncValues(state.feed, defaultStyle);
          final fontSize = _fontSize!;
          final fontHeight = _fontHeight!;

          return Column(
            crossAxisAlignment: .stretch,
            mainAxisSize: .min,
            children: [
              _FeedTitleSlider(
                label: 'Размер шрифта',
                value: fontSize,
                min: 18,
                max: 30,
                divisions: 12,
                valueFormatter: (value) => value.toStringAsFixed(0),
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                },
                onChangeEnd: (value) => context
                    .read<SettingsCubit>()
                    .changeFeedTitleFontSize(value),
              ),
              _FeedTitleSlider(
                label: 'Межстрочный интервал',
                value: fontHeight,
                min: 1,
                max: 1.5,
                divisions: 10,
                valueFormatter: (value) => value.toStringAsFixed(2),
                onChanged: (value) {
                  setState(() {
                    _fontHeight = value;
                  });
                },
                onChangeEnd: (value) => context
                    .read<SettingsCubit>()
                    .changeFeedTitleFontHeight(value),
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
                      'Пример заголовка публикации в ленте',
                      style: previewStyle.copyWith(
                        fontSize: fontSize,
                        height: fontHeight,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}

class _FeedTitleSlider extends StatefulWidget {
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
  final int divisions;
  final String Function(double value) valueFormatter;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  @override
  State<_FeedTitleSlider> createState() => _FeedTitleSliderState();
}

class _FeedTitleSliderState extends State<_FeedTitleSlider> {
  late double value;

  @override
  void initState() {
    super.initState();

    value = widget.value;
  }

  @override
  void didUpdateWidget(covariant _FeedTitleSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      value = widget.value;
    }
  }

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
                  widget.label,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                widget.valueFormatter(value),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Slider(
          label: widget.label,
          value: value,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
            widget.onChanged(newValue);
          },
          onChangeEnd: widget.onChangeEnd,
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
