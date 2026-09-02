import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../data/model/language/language.dart';
import '../../../i18n/i18n.dart';
import 'model/config_model.dart';
import 'widget/settings_card_widget.dart';
import 'widget/settings_checkbox_widget.dart';
import 'widget/settings_nested_scaffold.dart';
import 'widget/settings_section_widget.dart';
import 'widget/settings_segmented_button.dart';

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
    return SettingsNestedScaffold(
      title: context.t.settings.interface.title,
      description: context.t.settings.interface.description,
      children: [
        SettingsSectionWidget(
          title: context.t.settings.interface.sections.appearance,
          children: [
            const UIThemeWidget(),
            const SettingScrollVariantWidget(),
          ],
        ),
        SettingsSectionWidget(
          title: context.t.settings.interface.sections.navigation,
          children: [const InterfaceNavigationWidget()],
        ),
        SettingsSectionWidget(
          title: context.t.settings.interface.sections.languages,
          children: [
            const UILangWidget(),
            const ArticlesLangWidget(),
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

  @override
  void initState() {
    super.initState();

    themeMode = context.read<SettingsCubit>().state.theme.mode;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = switch (themeMode) {
      .system => MediaQuery.platformBrightnessOf(context) == .dark,
      .light => false,
      .dark => true,
    };

    return SettingsCardWidget(
      icon: Icons.palette_outlined,
      title: context.t.settings.interface.theme.title,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          SettingsSegmentedButton<ThemeMode>(
            segments: [
              ButtonSegment(
                value: .system,
                icon: const Icon(Icons.brightness_auto_rounded),
                label: Text(context.t.settings.interface.theme.system),
              ),
              ButtonSegment(
                value: .light,
                icon: const Icon(Icons.light_mode_outlined),
                label: Text(context.t.settings.interface.theme.light),
              ),
              ButtonSegment(
                value: .dark,
                icon: const Icon(Icons.dark_mode_outlined),
                label: Text(context.t.settings.interface.theme.dark),
              ),
            ],
            value: themeMode,
            onChanged: (mode) {
              setState(() => themeMode = mode);
              context.read<SettingsCubit>().changeTheme(mode);
            },
          ),
          if (isDarkTheme) ...[
            const Padding(
              padding: .symmetric(vertical: 12),
              child: Divider(height: 1),
            ),
            SettingsCheckboxWidget(
              initialValue: context
                  .read<SettingsCubit>()
                  .state
                  .theme
                  .isAmoledTheme,
              icon: Icons.contrast_rounded,
              title: Text(context.t.settings.interface.theme.amoled.label),
              subtitle: Text(
                context.t.settings.interface.theme.amoled.description,
              ),
              onChanged: (isEnabled) {
                context.read<SettingsCubit>().changeAmoledTheme(
                  isEnabled: isEnabled,
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

class InterfaceNavigationWidget extends StatelessWidget {
  const InterfaceNavigationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final translation = context.t.settings.interface.navigation;

    return SettingsCardWidget(
      icon: Icons.dock_outlined,
      title: translation.title,
      child: Column(
        crossAxisAlignment: .stretch,
        children: [
          Text(
            translation.alignment.label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 8),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.misc.navigationAlignment !=
                current.misc.navigationAlignment,
            builder: (context, state) {
              return SettingsSegmentedButton<NavigationAlignment>(
                segments: NavigationAlignment.values
                    .map(
                      (alignment) => ButtonSegment(
                        value: alignment,
                        label: Text(alignment.label),
                      ),
                    )
                    .toList(),
                value: state.misc.navigationAlignment,
                onChanged: context
                    .read<SettingsCubit>()
                    .changeNavigationAlignment,
              );
            },
          ),
          const Padding(
            padding: .symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
          BlocBuilder<SettingsCubit, SettingsState>(
            buildWhen: (previous, current) =>
                previous.misc.navigationOnScrollVisible !=
                current.misc.navigationOnScrollVisible,
            builder: (context, state) {
              return SettingsCheckboxWidget(
                initialValue: state.misc.navigationOnScrollVisible,
                icon: Icons.swipe_vertical_outlined,
                title: Text(translation.showOnScroll),
                onChanged: (isVisible) {
                  context
                      .read<SettingsCubit>()
                      .changeNavigationOnScrollVisibility(isVisible: isVisible);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class UILangWidget extends StatelessWidget {
  const UILangWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      icon: Icons.translate_rounded,
      title: context.t.settings.interface.language.ui,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) => previous.langUI != current.langUI,
        builder: (context, state) {
          return SettingsSegmentedButton<Language>(
            segments: Language.values
                .map(
                  (lang) => ButtonSegment(
                    value: lang,
                    label: Text(
                      switch (lang) {
                        .ru => context.t.language.russian,
                        .en => context.t.language.english,
                      },
                    ),
                  ),
                )
                .toList(),
            value: state.langUI,
            onChanged: context.read<SettingsCubit>().changeUILang,
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
    final settingsCubit = context.read<SettingsCubit>();

    return SettingsCardWidget(
      icon: Icons.language_rounded,
      title: context.t.settings.interface.language.publications.label,
      subtitle: context.t.settings.interface.language.publications.required,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.langArticles != current.langArticles,
        builder: (context, state) {
          return Column(
            mainAxisSize: .min,
            children: [
              for (final (index, lang) in Language.values.indexed) ...[
                if (index > 0) const Divider(height: 1),
                SettingsCheckboxWidget(
                  type: .checkboxTile,
                  title: Text(lang.label),
                  initialValue: state.langArticles.contains(lang),
                  validate: (value) =>
                      settingsCubit.validateLang(lang, isEnabled: value).$1,
                  onChanged: (value) =>
                      settingsCubit.changeArticleLang(lang, isEnabled: value),
                ),
              ],
            ],
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
      icon: Icons.swipe_vertical_rounded,
      title: context.t.settings.interface.scroll,
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous.misc.scrollVariant != current.misc.scrollVariant,
        builder: (context, state) {
          return SettingsSegmentedButton<ScrollVariant>(
            segments: ScrollVariant.values
                .map(
                  (variant) => ButtonSegment(
                    value: variant,
                    label: Text(variant.label),
                  ),
                )
                .toList(),
            value: state.misc.scrollVariant,
            onChanged: context.read<SettingsCubit>().changeScrollVariant,
          );
        },
      ),
    );
  }
}
