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
        const FeedConfigWidget(),
      ],
    );
  }
}

class UIThemeWidget extends StatelessWidget {
  const UIThemeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
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
    return _SettingCard(
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
    return _SettingCard(
      title: 'Язык публикаций',
      subtitle: 'должен быть выбран хотя бы один',
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (p, c) => p.langArticles != c.langArticles,
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
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
          );
        },
      ),
    );
  }
}

class FeedConfigWidget extends StatelessWidget {
  const FeedConfigWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _SettingCard(
      title: 'Карточки статей',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (p, c) =>
                p.feedConfig.isImageVisible != c.feedConfig.isImageVisible,
            builder: (context, state) {
              return CheckboxListTile(
                title: const Text('Изображение'),
                value: state.feedConfig.isImageVisible,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool? value) {
                  context
                      .read<SettingsCubit>()
                      .changeFeedImageVisibility(isVisible: value);
                },
              );
            },
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (p, c) =>
                p.feedConfig.isDescriptionVisible !=
                c.feedConfig.isDescriptionVisible,
            builder: (context, state) {
              return CheckboxListTile(
                title: const Text('Короткое описание'),
                subtitle: const Text('влияет на производительность'),
                contentPadding: EdgeInsets.zero,
                value: state.feedConfig.isDescriptionVisible,
                onChanged: (bool? value) {
                  context
                      .read<SettingsCubit>()
                      .changeFeedDescVisibility(isVisible: value);
                },
              );
            },
          ),
        ],
      ),
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
            mainAxisSize: MainAxisSize.min,
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
