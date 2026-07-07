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
import 'widget/text_style_typography_widget.dart';

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
    return TextStyleTypographyWidget(
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
    return TextStyleTypographyWidget(
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
  final textTheme = AppTypography.textTheme(scheme: context.theme.colorScheme);

  return AppTypographyExtension.fromTextTheme(textTheme);
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
