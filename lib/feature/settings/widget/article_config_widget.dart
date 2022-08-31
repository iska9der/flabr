import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/settings_cubit.dart';

class ArticleConfigWidget extends StatelessWidget {
  const ArticleConfigWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Text(
            'Размер шрифта',
            style: titleStyle,
          ),
        ),
        FontScaleSlider(
          initialScale:
              context.read<SettingsCubit>().state.articleConfig.fontScale,
        ),
        const SizedBox(height: 12),
        BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            return CheckboxListTile(
              title: Text('Показывать изображения?', style: titleStyle),
              value: state.articleConfig.isImagesVisible,
              onChanged: (bool? value) {
                context
                    .read<SettingsCubit>()
                    .changeArticleImageVisibility(isVisible: value);
              },
            );
          },
        )
      ],
    );
  }
}

class FontScaleSlider extends StatefulWidget {
  const FontScaleSlider({Key? key, required this.initialScale})
      : super(key: key);

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
          max: 1.2,
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
