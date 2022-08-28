import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/language.dart';
import '../config/constants.dart';
import '../feature/settings/cubit/settings_cubit.dart';
import '../widget/card_widget.dart';

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
  const SettingsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const ownPadding = 22.0;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: kScreenHPadding),
      children: const [
        SizedBox(height: ownPadding),
        UIThemeWidget(),
        SizedBox(height: ownPadding),
        UILangWidget(),
        SizedBox(height: ownPadding),
        ArticlesLangWidget(),
      ],
    );
  }
}

class UIThemeWidget extends StatelessWidget {
  const UIThemeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return _SettingCard(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SwitchListTile.adaptive(
            title: const Text('Темная тема'),
            contentPadding: EdgeInsets.zero,
            value: state.isDarkTheme,
            onChanged: (val) {
              context.read<SettingsCubit>().changeTheme(isDarkTheme: val);
            },
          ),
        );
      },
    );
  }
}

class UILangWidget extends StatelessWidget {
  const UILangWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return _SettingCard(
          title: 'Язык интерфейса',
          child: DropdownButton(
            hint: const Text('Язык'),
            isExpanded: true,
            underline: Container(),
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
          ),
        );
      },
    );
  }
}

class ArticlesLangWidget extends StatelessWidget {
  const ArticlesLangWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return _SettingCard(
          title: 'Язык публикаций',
          subtitle: 'должен быть выбран хотя бы один',
          child: Column(
            children: LanguageEnum.values
                .map(
                  (lang) => CheckboxListTile(
                    title: Text(lang.label),
                    contentPadding: EdgeInsets.zero,
                    value: state.langArticles.contains(lang),
                    onChanged: (bool? val) {
                      context
                          .read<SettingsCubit>()
                          .changeArticlesLang(lang, isEnabled: val);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}

class _SettingCard extends StatelessWidget {
  const _SettingCard({
    Key? key,
    this.title,
    this.subtitle,
    this.padding = const EdgeInsets.all(20),
    required this.child,
  }) : super(key: key);

  final String? title;
  final String? subtitle;
  final EdgeInsets padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FlabrCard(
          padding: padding,
          child: child,
        ),
        Positioned(
          left: 6,
          top: -10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) Text(title!),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.caption,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
