import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings/settings_cubit.dart';

class PublicationSettingsWidget extends StatelessWidget {
  const PublicationSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text(
            'Размер шрифта',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        FontScaleSlider(
          initialScale:
              context.read<SettingsCubit>().state.publication.fontScale,
        ),
        const SizedBox(height: 12),
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return SwitchListTile(
              title: const Text('Изображения'),
              value: state.publication.isImagesVisible,
              onChanged: (bool? value) {
                context.read<SettingsCubit>().changeArticleImageVisibility(
                  isVisible: value,
                );
              },
            );
          },
        ),
        const SizedBox(height: 12),
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return SwitchListTile(
              title: const Text('WebView'),
              value: state.publication.webViewEnabled,
              onChanged: (bool? value) {
                context.read<SettingsCubit>().changeWebViewVisibility(
                  isVisible: value,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class FontScaleSlider extends StatefulWidget {
  const FontScaleSlider({super.key, required this.initialScale});

  final double initialScale;

  @override
  State<FontScaleSlider> createState() => _FontScaleSliderState();
}

class _FontScaleSliderState extends State<FontScaleSlider> {
  double sliderValue = 1;

  static const double _min = 0.92;
  static const double _max = 1.7;

  @override
  void initState() {
    double initial = widget.initialScale;

    if (initial < _min) {
      initial = _min;
    } else if (initial > _max) {
      initial = _max;
    }

    sliderValue = initial;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Slider(
          label: 'Размер шрифта',
          value: sliderValue,
          min: _min,
          max: _max,
          onChanged: (value) {
            setState(() {
              sliderValue = value;
            });
          },
          onChangeEnd: (value) {
            context.read<SettingsCubit>().changeArticleFontScale(value);
          },
        );
      },
    );
  }
}
