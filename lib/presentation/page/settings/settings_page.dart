import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/language/part.dart';
import '../../theme/part.dart';
import '../../widget/publication_settings_widget.dart';
import 'cubit/settings_cubit.dart';
import 'widget/account/connect_sid_widget.dart';
import 'widget/account/summary_token_widget.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: kScreenHPadding),
          children: const [
            SettingsSectionWidget(
              title: 'Аккаунт',
              children: [
                ConnectSidWidget(),
                SummaryTokenWidget(),
              ],
            ),
            SettingsSectionWidget(
              title: 'Интерфейс',
              children: [
                UIThemeWidget(),
                UILangWidget(),
                ArticlesLangWidget(),
              ],
            ),
            SettingsSectionWidget(
              title: 'Лента',
              children: [
                SettingsFeedWidget(),
                SettingNavVisibilityWidget(),
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
  late bool isDarkTheme;
  bool isLoading = false;

  @override
  void initState() {
    isDarkTheme = context.read<SettingsCubit>().state.theme.isDarkTheme;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Цветовая схема',
      child: SwitchListTile.adaptive(
        title: const Text('Темная тема'),
        contentPadding: EdgeInsets.zero,
        value: isDarkTheme,
        onChanged: (val) {
          if (isLoading) {
            return;
          }
          final settingsCubit = context.read<SettingsCubit>();

          setState(() {
            isDarkTheme = val;
            isLoading = true;
          });

          Future.delayed(const Duration(milliseconds: 600), () {
            settingsCubit.changeTheme(isDarkTheme: val);
            setState(() {
              isLoading = false;
            });
          });
        },
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
              DropdownMenuItem(
                value: Language.ru,
                child: Text('Русский'),
              ),
              DropdownMenuItem(
                value: Language.en,
                child: Text('Английский'),
              ),
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
            children: Language.values
                .map(
                  (lang) => SettingsCheckboxWidget(
                    type: SettingsCheckboxType.checkboxTile,
                    title: Text(lang.label),
                    initialValue: state.langArticles.contains(lang),
                    validate: (bool val) => context
                        .read<SettingsCubit>()
                        .validateChangeArticlesLang(lang, isEnabled: val)
                        .$1,
                    onChanged: (bool? val) => context
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
            onChanged: (bool value) =>
                settingsCubit.changeFeedImageVisibility(isVisible: value),
          ),
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feed.isDescriptionVisible,
            title: const Text('Короткое описание'),
            subtitle: const Text('влияет на производительность'),
            onChanged: (bool value) =>
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
    );
  }
}
