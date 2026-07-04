import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../extension/extension.dart';
import '../page/settings/model/config_model.dart';
import '../page/settings/widget/settings_card_widget.dart';
import '../page/settings/widget/settings_checkbox_widget.dart';

class PublicationSettingsWidget extends StatelessWidget {
  const PublicationSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      spacing: 4,
      children: [
        const PublicationFontScaleWidget(),
        SettingsCardWidget(
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.publication.isImagesVisible !=
                    current.publication.isImagesVisible,
                builder: (context, state) {
                  return SettingsCheckboxWidget(
                    initialValue: state.publication.isImagesVisible,
                    title: const Text('Изображения'),
                    onChanged: (bool value) => context
                        .read<SettingsCubit>()
                        .changeArticleImageVisibility(isVisible: value),
                  );
                },
              ),
              BlocBuilder<SettingsCubit, SettingsState>(
                buildWhen: (previous, current) =>
                    previous.publication.webViewEnabled !=
                    current.publication.webViewEnabled,
                builder: (context, state) {
                  return SettingsCheckboxWidget(
                    initialValue: state.publication.webViewEnabled,
                    title: const Text('WebView'),
                    onChanged: (bool value) => context
                        .read<SettingsCubit>()
                        .changeWebViewVisibility(isVisible: value),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PublicationFontScaleWidget extends StatelessWidget {
  const PublicationFontScaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.publication.fontScale != current.publication.fontScale,
      builder: (context, state) {
        return FontScaleCard(fontScale: state.publication.fontScale);
      },
    );
  }
}

class FontScaleCard extends StatefulWidget {
  const FontScaleCard({super.key, required this.fontScale});

  final double fontScale;

  @override
  State<FontScaleCard> createState() => _FontScaleCardState();
}

class _FontScaleCardState extends State<FontScaleCard> {
  static const double _minFontSize = 12;
  static const double _maxFontSize = 24;

  late double _defaultFontSize;
  late double _fontSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _syncValue();
  }

  @override
  void didUpdateWidget(covariant FontScaleCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.fontScale != widget.fontScale) {
      _syncValue();
    }
  }

  double _scaleToFontSize(BuildContext context, double scale) {
    return _defaultFontSize * scale;
  }

  double _fontSizeToScale(BuildContext context, double fontSize) {
    return fontSize / _defaultFontSize;
  }

  void _syncValue() {
    _defaultFontSize = context.theme.textTheme.bodyMedium!.fontSize!;

    _fontSize = _scaleToFontSize(
      context,
      widget.fontScale,
    ).clamp(_minFontSize, _maxFontSize).toDouble();
  }

  void _reset(BuildContext context) {
    setState(() => _fontSize = _defaultFontSize);
    context.read<SettingsCubit>().changeArticleFontScale(
      PublicationConfigModel.defaultScale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return SettingsCardWidget(
      title: 'Размер шрифта',
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
          _FontScaleSlider(
            value: _fontSize,
            min: _minFontSize,
            max: _maxFontSize,
            onChanged: (value) => setState(() => _fontSize = value),
            onChangeEnd: (value) => context
                .read<SettingsCubit>()
                .changeArticleFontScale(_fontSizeToScale(context, value)),
          ),
          Padding(
            padding: const .symmetric(horizontal: 16.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: .circular(8),
              ),
              child: Padding(
                padding: const .all(12.0),
                child: Text(
                  'Пример текста публикации.\n'
                  'Так проще оценить размер и ритм строки',
                  style: theme.textTheme.bodyMedium?.apply(
                    fontSizeFactor: _fontSizeToScale(context, _fontSize),
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

class _FontScaleSlider extends StatelessWidget {
  const _FontScaleSlider({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
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
                  'Размер шрифта',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Text(
                value.toStringAsFixed(0),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Slider(
          label: 'Размер шрифта',
          value: value,
          min: min,
          max: max,
          divisions: (max - min).round(),
          onChanged: onChanged,
          onChangeEnd: onChangeEnd,
        ),
      ],
    );
  }
}
