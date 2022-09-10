import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/language.dart';
import '../config/constants.dart';
import '../feature/settings/cubit/settings_cubit.dart';
import '../feature/settings/widget/settings_card_widget.dart';
import '../feature/settings/widget/settings_checkbox_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SettingsView()),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    const hBetweenSub = 22.0;
    const hAfterHeadline = 16.0;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: kScreenHPadding),
      children: [
        const SizedBox(height: hBetweenSub),
        Text(
          'Интерфейс',
          style: textTheme.headline4,
        ),
        const UIThemeWidget(),
        const SizedBox(height: hBetweenSub),
        const UILangWidget(),
        const SizedBox(height: hBetweenSub),
        const ArticlesLangWidget(),
        const SizedBox(height: hBetweenSub),
        Text(
          'Лента',
          style: textTheme.headline4,
        ),
        const SizedBox(height: hAfterHeadline),
        const SettingsFeedWidget(),
      ],
    );
  }
}

class UIThemeWidget extends StatelessWidget {
  const UIThemeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (p, c) => p.isDarkTheme != c.isDarkTheme,
        builder: (context, state) {
          return SwitchListTile.adaptive(
            title: const Text('Темная тема'),
            contentPadding: EdgeInsets.zero,
            value: state.isDarkTheme,
            onChanged: (val) {
              context.read<SettingsCubit>().changeTheme(isDarkTheme: val);
            },
          );
        },
      ),
    );
  }
}

class UILangWidget extends StatelessWidget {
  const UILangWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Язык интерфейса',
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (p, c) => p.langUI != c.langUI,
        builder: (context, state) {
          return DropdownButton(
            hint: const Text('Язык'),
            isExpanded: true,
            underline: const SizedBox(),
            value: state.langUI,
            items: const [
              DropdownMenuItem(
                value: LanguageEnum.ru,
                child: Text('Русский'),
              ),
              DropdownMenuItem(
                value: LanguageEnum.en,
                child: Text('Английский'),
              ),
            ],
            onChanged: (LanguageEnum? value) {
              context.read<SettingsCubit>().changeUILang(value);
            },
          );
        },
      ),
    );
  }
}

class ArticlesLangWidget extends StatelessWidget {
  const ArticlesLangWidget({Key? key}) : super(key: key);

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
            children: LanguageEnum.values
                .map(
                  (lang) => SettingsCheckboxWidget(
                    title: Text(lang.label),
                    initialValue: state.langArticles.contains(lang),
                    validate: (bool val) => context
                        .read<SettingsCubit>()
                        .validateChangeArticlesLang(lang, isEnabled: val),
                    onChanged: (bool? val) => context
                        .read<SettingsCubit>()
                        .changeArticlesLang(lang, isEnabled: val),
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
  const SettingsFeedWidget({Key? key}) : super(key: key);

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
            initialValue: settingsCubit.state.feedConfig.isImageVisible,
            title: const Text('Изображение'),
            onChanged: (bool value) =>
                settingsCubit.changeFeedImageVisibility(isVisible: value),
          ),
          SettingsCheckboxWidget(
            initialValue: settingsCubit.state.feedConfig.isDescriptionVisible,
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
