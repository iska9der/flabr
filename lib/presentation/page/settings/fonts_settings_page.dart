import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../widget/publication_typography_widget.dart';
import 'model/config_model.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';
import 'widget/settings_slider_widget.dart';

@RoutePage()
class FontsSettingsPage extends StatelessWidget {
  const FontsSettingsPage({super.key});

  static const String routePath = 'fonts';

  @override
  Widget build(BuildContext context) {
    return const FontsSettingsView();
  }
}

class FontsSettingsView extends StatelessWidget {
  const FontsSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsNestedScaffold(
      title: 'Шрифты',
      children: [
        SettingsSectionWidget(
          title: 'Общее',
          children: [
            TextScaleFactorWidget(),
          ],
        ),
        SettingsSectionWidget(
          title: 'Публикации',
          children: [
            PublicationTitleTypographyWidget(),
            PublicationTextTypographyWidget(),
          ],
        ),
      ],
    );
  }
}

class TextScaleFactorWidget extends StatelessWidget {
  const TextScaleFactorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.typography.textScaleFactor !=
          current.typography.textScaleFactor,
      builder: (context, state) {
        return _TextScaleFactorCard(value: state.typography.textScaleFactor);
      },
    );
  }
}

class _TextScaleFactorCard extends StatefulWidget {
  const _TextScaleFactorCard({required this.value});

  final double value;

  @override
  State<_TextScaleFactorCard> createState() => _TextScaleFactorCardState();
}

class _TextScaleFactorCardState extends State<_TextScaleFactorCard> {
  late double _value;

  @override
  void initState() {
    super.initState();

    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant _TextScaleFactorCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  String _format(double value) {
    return '${(value * 100).round()}%';
  }

  @override
  Widget build(BuildContext context) {
    final divisions =
        ((TypographyConfigModel.maxTextScaleFactor -
                    TypographyConfigModel.minTextScaleFactor) *
                20)
            .round();

    return SettingsCardWidget(
      child: SettingsSliderWidget(
        label: 'Масштаб текста',
        value: _value,
        min: TypographyConfigModel.minTextScaleFactor,
        max: TypographyConfigModel.maxTextScaleFactor,
        divisions: divisions,
        valueFormatter: _format,
        sliderLabel: _format(_value),
        onChanged: (value) => setState(() => _value = value),
        onChangeEnd: (value) =>
            context.read<SettingsCubit>().changeTextScaleFactor(value),
      ),
    );
  }
}
