import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../page/settings/cubit/settings_cubit.dart';

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
              context.read<SettingsCubit>().state.publicationConfig.fontScale,
        ),
        const SizedBox(height: 12),
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return SwitchListTile.adaptive(
              title: const Text('Изображения'),
              value: state.publicationConfig.isImagesVisible,
              onChanged: (bool? value) {
                context
                    .read<SettingsCubit>()
                    .changeArticleImageVisibility(isVisible: value);
              },
            );
          },
        ),
        const SizedBox(height: 12),
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return SwitchListTile.adaptive(
              title: const Text('WebView'),
              value: state.publicationConfig.webViewEnabled,
              onChanged: (bool? value) {
                context
                    .read<SettingsCubit>()
                    .changeWebViewVisibility(isVisible: value);
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

  @override
  void initState() {
    sliderValue = widget.initialScale;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return Slider.adaptive(
          label: 'Размер шрифта',
          value: sliderValue,
          min: 0.8,
          max: 1.4,
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
