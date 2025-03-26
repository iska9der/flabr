import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../../data/model/filter/filter.dart';
import '../../../data/model/language/language.dart';
import '../../../feature/auth/widget/connect_sid_widget.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../../widget/filter/filter_chip_list.dart';
import '../../widget/publication_settings_widget.dart';
import 'cubit/settings_cubit.dart';
import 'model/config_model.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_checkbox_widget.dart';
import 'widget/settings_section_widget.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routePath = 'settings';

  @override
  Widget build(BuildContext context) {
    return const SettingsView();
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: AppInsets.screenPadding.copyWith(top: 0),
          children: [
            SettingsSectionWidget(
              title: 'Аккаунт',
              children: [
                SettingsCardWidget(
                  title: 'connect_sid',
                  subtitle: 'Если не удается войти через форму логина',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ConnectSidWidget(),
                  ),
                ),
                SettingsCardWidget(
                  title: 'YandexGPT',
                  subtitle: 'Для генерации пересказов статей',
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SummaryTokenWidget(
                      onShowSnack: (text) {
                        context.showSnack(content: Text(text));
                      },
                    ),
                  ),
                ),
              ],
            ),
            SettingsSectionWidget(
              title: 'Интерфейс',
              children: [UIThemeWidget(), UILangWidget(), ArticlesLangWidget()],
            ),
            SettingsSectionWidget(
              title: 'Лента',
              children: [
                SettingsFeedWidget(),
                SettingNavVisibilityWidget(),
                SettingScrollVariantWidget(),
              ],
            ),
            SettingsSectionWidget(
              title: 'Публикации',
              children: [
                SettingsCardWidget(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: PublicationSettingsWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UIThemeWidget extends StatefulWidget {
  const UIThemeWidget({super.key});

  @override
  State<UIThemeWidget> createState() => _UIThemeWidgetState();
}

class _UIThemeWidgetState extends State<UIThemeWidget> {
  late ThemeMode themeMode;
  bool isLoading = false;

  @override
  void initState() {
    themeMode = context.read<SettingsCubit>().state.theme.mode;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Цветовая тема',
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: FilterChipList(
          options:
              ThemeMode.values
                  .map(
                    (e) => FilterOption(
                      label: switch (e) {
                        ThemeMode.system => 'Системная',
                        ThemeMode.light => 'Светлая',
                        ThemeMode.dark => 'Темная',
                      },
                      value: e.name,
                    ),
                  )
                  .toList(),
          isSelected: (option) => option.value == themeMode.name,
          onSelected: (isSelected, option) {
            if (isLoading) {
              return;
            }
            final settingsCubit = context.read<SettingsCubit>();

            setState(() {
              themeMode = ThemeMode.values.firstWhere(
                (e) => e.name == option.value,
              );
              isLoading = true;
            });

            Future.delayed(const Duration(milliseconds: 600), () {
              settingsCubit.changeTheme(themeMode);
              setState(() {
                isLoading = false;
              });
            });
          },
        ),
      ),
    );
  }
}

class UILangWidget extends StatelessWidget {
  const UILangWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Язык интерфейса',
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.langUI != current.langUI,
        builder: (context, state) {
          return DropdownButton(
            hint: const Text('Язык'),
            isExpanded: true,
            underline: const SizedBox(),
            value: state.langUI,
            items: const [
              DropdownMenuItem(value: Language.ru, child: Text('Русский')),
              DropdownMenuItem(value: Language.en, child: Text('Английский')),
            ],
            onChanged: (Language? value) {
              context.read<SettingsCubit>().changeUILang(value);
            },
          );
        },
      ),
    );
  }
}

class ArticlesLangWidget extends StatelessWidget {
  const ArticlesLangWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Язык публикаций',
      subtitle: 'должен быть выбран хотя бы один',
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (p, c) => p.langArticles != c.langArticles,
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children:
                Language.values
                    .map(
                      (lang) => SettingsCheckboxWidget(
                        type: SettingsCheckboxType.checkboxTile,
                        title: Text(lang.label),
                        initialValue: state.langArticles.contains(lang),
                        validate:
                            (bool val) =>
                                context
                                    .read<SettingsCubit>()
                                    .validateChangeArticlesLang(
                                      lang,
                                      isEnabled: val,
                                    )
                                    .$1,
                        onChanged:
                            (bool? val) => context
                                .read<SettingsCubit>()
                                .changeArticleLang(lang, isEnabled: val),
                      ),
                    )
                    .toList(),
          );
        },
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feed.isImageVisible,
            title: const Text('Изображения'),
            onChanged:
                (bool value) =>
                    settingsCubit.changeFeedImageVisibility(isVisible: value),
          ),
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feed.isDescriptionVisible,
            title: const Text('Короткое описание'),
            subtitle: const Text('влияет на производительность'),
            onChanged:
                (bool value) =>
                    settingsCubit.changeFeedDescVisibility(isVisible: value),
          ),
        ],
      ),
    );
  }
}

class SettingNavVisibilityWidget extends StatelessWidget {
  const SettingNavVisibilityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Навигация',
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen:
            (previous, current) =>
                previous.misc.navigationOnScrollVisible !=
                current.misc.navigationOnScrollVisible,
        builder: (context, state) {
          return SettingsCheckboxWidget(
            initialValue: state.misc.navigationOnScrollVisible,
            title: const Text('Показывать при скролле'),
            onChanged:
                (bool value) => context
                    .read<SettingsCubit>()
                    .changeNavigationOnScrollVisibility(isVisible: value),
          );
        },
      ),
    );
  }
}

class SettingScrollVariantWidget extends StatelessWidget {
  const SettingScrollVariantWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Скролл',
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen:
            (previous, current) =>
                previous.misc.scrollVariant != current.misc.scrollVariant,
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: FilterChipList(
              options:
                  ScrollVariant.values
                      .map((e) => FilterOption(label: e.label, value: e.label))
                      .toList(),
              isSelected:
                  (option) => state.misc.scrollVariant.label == option.label,
              onSelected: (isSelected, option) {
                final newVariant = ScrollVariant.values.firstWhere(
                  (element) => element.label == option.value,
                );

                context.read<SettingsCubit>().changeScrollVariant(newVariant);
              },
            ),
          );
        },
      ),
    );
  }
}
