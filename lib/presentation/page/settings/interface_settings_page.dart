import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../data/model/filter/filter.dart';
import '../../../data/model/language/language.dart';
import '../../widget/filter/filter_chip_list.dart';
import 'model/config_model.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_checkbox_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';

@RoutePage()
class InterfaceSettingsPage extends StatelessWidget {
  const InterfaceSettingsPage({super.key});

  static const String routePath = 'interface';

  @override
  Widget build(BuildContext context) {
    return const InterfaceSettingsView();
  }
}

class InterfaceSettingsView extends StatelessWidget {
  const InterfaceSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsNestedScaffold(
      title: 'Интерфейс',
      children: [
        SettingsSectionWidget(
          title: 'Внешний вид',
          children: [
            UIThemeWidget(),
            SettingScrollVariantWidget(),
          ],
        ),
        SettingsSectionWidget(
          title: 'Языки',
          children: [
            UILangWidget(),
            ArticlesLangWidget(),
          ],
        ),
      ],
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
    super.initState();

    themeMode = context.read<SettingsCubit>().state.theme.mode;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Цветовая тема',
      child: Padding(
        padding: const .only(top: 8.0),
        child: FilterChipList(
          options: ThemeMode.values
              .map(
                (e) => FilterOption(
                  label: switch (e) {
                    .system => 'Системная',
                    .light => 'Светлая',
                    .dark => 'Темная',
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
              themeMode = .values.firstWhere((e) => e.name == option.value);
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
      child: Padding(
        padding: const .only(top: 8.0),
        child: BlocBuilder<SettingsCubit, SettingsState>(
          buildWhen: (previous, current) => previous.langUI != current.langUI,
          builder: (context, state) {
            return FilterChipList(
              options: Language.values
                  .map(
                    (lang) => FilterOption(
                      value: lang.name,
                      label: switch (lang) {
                        .ru => 'Русский',
                        .en => 'Английский',
                      },
                    ),
                  )
                  .toList(),
              isSelected: (option) => option.value == state.langUI.name,
              onSelected: (isSelected, option) {
                final newLang = Language.fromString(option.value);
                context.read<SettingsCubit>().changeUILang(newLang);
              },
            );
          },
        ),
      ),
    );
  }
}

class ArticlesLangWidget extends StatelessWidget {
  const ArticlesLangWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return SettingsCardWidget(
      title: 'Язык публикаций',
      subtitle: 'должен быть выбран хотя бы один',
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (p, c) => p.langArticles != c.langArticles,
        builder: (context, state) {
          return Column(
            mainAxisSize: .min,
            children: Language.values
                .map(
                  (lang) => SettingsCheckboxWidget(
                    type: .checkboxTile,
                    title: Text(lang.label),
                    initialValue: state.langArticles.contains(lang),
                    validate: (bool val) =>
                        settingsCubit.validateLang(lang, isEnabled: val).$1,
                    onChanged: (bool? val) =>
                        settingsCubit.changeArticleLang(lang, isEnabled: val),
                  ),
                )
                .toList(),
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
        buildWhen: (previous, current) =>
            previous.misc.scrollVariant != current.misc.scrollVariant,
        builder: (context, state) {
          return Padding(
            padding: const .only(top: 8.0),
            child: FilterChipList(
              options: ScrollVariant.values
                  .map((e) => FilterOption(label: e.label, value: e.label))
                  .toList(),
              isSelected: (option) =>
                  state.misc.scrollVariant.label == option.label,
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
