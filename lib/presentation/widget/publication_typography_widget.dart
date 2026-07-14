import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings/settings_cubit.dart';
import '../extension/extension.dart';
import '../page/settings/widget/text_style_typography_widget.dart';
import '../theme/theme.dart';

class PublicationTitleTypographyWidget extends StatelessWidget {
  const PublicationTitleTypographyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextStyleTypographyWidget(
      title: 'Заголовок',
      previewText: 'Пример заголовка публикации',
      styleSelector: (state) => state.typography.titleStyle,
      defaultStyleBuilder: (context) =>
          _defaultTypography(context).publicationTitle,
      previewStyleBuilder: (context) =>
          context.theme.appTypography.publicationTitle,
      onStyleChange: (context, style) =>
          context.read<SettingsCubit>().changePublicationTitleStyle(style),
      fontSizeMin: 20,
      fontSizeMax: 30,
      fontHeightMax: 1.3,
    );
  }
}

class PublicationTextTypographyWidget extends StatelessWidget {
  const PublicationTextTypographyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return TextStyleTypographyWidget(
      title: 'Текст',
      previewText:
          'Пример текста публикации.\n'
          'Так проще оценить размер и ритм строки',
      styleSelector: (state) => state.typography.textStyle,
      defaultStyleBuilder: (context) =>
          _defaultTypography(context).publicationText,
      previewStyleBuilder: (context) =>
          context.theme.appTypography.publicationText,
      onStyleChange: (context, style) =>
          context.read<SettingsCubit>().changePublicationTextStyle(style),
      fontSizeMin: 12,
      fontSizeMax: 24,
      fontHeightMax: 1.8,
    );
  }
}

UserTypographyExtension _defaultTypography(BuildContext context) {
  final textTheme = AppTypography.textTheme(scheme: context.theme.colorScheme);

  return UserTypographyExtension.create(textTheme);
}
