import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../extension/extension.dart';
import '../page/settings/widget/settings_card_widget.dart';
import '../page/settings/widget/settings_checkbox_widget.dart';
import '../page/settings/widget/text_style_typography_widget.dart';
import '../theme/theme.dart';

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
    final publicationTextStyle = _defaultTypography(context).publicationText;

    return TextStyleTypographyWidget(
      title: 'Текст',
      previewText:
          'Пример текста публикации.\n'
          'Так проще оценить размер и ритм строки',
      styleSelector: (state) => state.publication.textStyle,
      defaultStyleBuilder: (context) => publicationTextStyle,
      previewStyleBuilder: (context) =>
          context.theme.appTypography.publicationText,
      onStyleChange: (context, style) =>
          context.read<SettingsCubit>().changeArticleTextStyle(style),
      fontSizeMin: 12,
      fontSizeMax: 24,
      fontHeightMax: 1.8,
    );
  }
}

AppTypographyExtension _defaultTypography(BuildContext context) {
  final textTheme = AppTypography.textTheme(
    scheme: context.theme.colorScheme,
  );

  return AppTypographyExtension.fromTextTheme(textTheme);
}
