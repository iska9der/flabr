import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../component/language.dart';
import '../feature/settings/cubit/settings_cubit.dart';

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
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        UIThemeWidget(),
        SizedBox(height: 12),
        UILangWidget(),
        SizedBox(height: 12),
        PostsLangWidget(),
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
            isDense: true,
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

class PostsLangWidget extends StatelessWidget {
  const PostsLangWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return _SettingCard(
          title: 'Язык постов',
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
      children: [
        Card(
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
        Column(
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
      ],
    );
  }
}
