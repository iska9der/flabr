import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../../bloc/settings/settings_cubit.dart';
import '../../../core/constants/constants.dart';
import '../../../data/model/filter/filter.dart';
import '../../../data/model/language/language.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../../widget/auth/auth.dart';
import '../../widget/filter/filter_chip_list.dart';
import '../../widget/profile/profile.dart';
import '../../widget/publication_settings_widget.dart';
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
          padding: AppInsets.screenPaddingExtended,
          children: [
            SettingsSectionWidget(
              children: [
                const AccountTile(),
                const SettingsCardWidget(
                  title: Keys.sidToken,
                  subtitle: 'Если не удается войти через форму логина',
                  child: Padding(
                    padding: .only(top: 12.0),
                    child: ConnectSidWidget(),
                  ),
                ),
                SettingsCardWidget(
                  title: 'YandexGPT',
                  subtitle: 'Для генерации пересказов статей',
                  child: Padding(
                    padding: const .only(top: 12.0),
                    child: SummaryTokenWidget(
                      onShowSnack: (text) {
                        context.showSnack(content: Text(text));
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SettingsSectionWidget(
              title: 'Интерфейс',
              children: [
                UIThemeWidget(),
                UILangWidget(),
                ArticlesLangWidget(),
              ],
            ),
            const SettingsSectionWidget(
              title: 'Лента',
              children: [
                SettingsFeedWidget(),
                SettingNavVisibilityWidget(),
                SettingScrollVariantWidget(),
              ],
            ),
            const SettingsSectionWidget(
              title: 'Публикации',
              children: [
                SettingsCardWidget(child: PublicationSettingsWidget()),
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

class SettingsFeedWidget extends StatelessWidget {
  const SettingsFeedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsCubit = context.read<SettingsCubit>();

    return SettingsCardWidget(
      title: 'Карточки статей',
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
          const SizedBox(height: 12),
          const FeedTitleTypographyWidget(),
        ],
      ),
    );
  }
}

class FeedTitleTypographyWidget extends StatefulWidget {
  const FeedTitleTypographyWidget({super.key});

  @override
  State<FeedTitleTypographyWidget> createState() =>
      _FeedTitleTypographyWidgetState();
}

class _FeedTitleTypographyWidgetState extends State<FeedTitleTypographyWidget> {
  double? _fontSize;
  double? _fontHeight;
  FeedConfigModel? _lastFeedConfig;

  TextStyle _defaultStyle(BuildContext context) {
    final textTheme = AppTypography.textTheme(
      scheme: context.theme.colorScheme,
    );

    return AppTypographyExtension.fromTextTheme(textTheme).feedPublicationTitle;
  }

  void _syncValues(FeedConfigModel feedConfig, TextStyle defaultStyle) {
    if (_lastFeedConfig == feedConfig) {
      return;
    }

    _fontSize = feedConfig.titleStyle?.size ?? defaultStyle.fontSize;
    _fontHeight = feedConfig.titleStyle?.height ?? defaultStyle.height;
    _lastFeedConfig = feedConfig;
  }

  @override
  Widget build(BuildContext context) {
    final defaultStyle = _defaultStyle(context);
    final previewStyle = context.theme.appTypography.feedPublicationTitle;

    return BlocBuilder<SettingsCubit, SettingsState>(
      buildWhen: (previous, current) =>
          previous.feed.titleStyle != current.feed.titleStyle,
      builder: (context, state) {
        _syncValues(state.feed, defaultStyle);
        final fontSize = _fontSize!;
        final fontHeight = _fontHeight!;

        return Column(
          crossAxisAlignment: .stretch,
          mainAxisSize: .min,
          children: [
            Padding(
              padding: const .symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Заголовки',
                      style: context.theme.textTheme.bodyLarge,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Вернуть значения по умолчанию',
                    onPressed: () {
                      setState(() {
                        _fontSize = defaultStyle.fontSize;
                        _fontHeight = defaultStyle.height;
                        _lastFeedConfig = null;
                      });
                      context.read<SettingsCubit>().resetFeedTitleTypography();
                    },
                    icon: const Icon(Icons.restart_alt_rounded),
                  ),
                ],
              ),
            ),
            _FeedTitleSlider(
              label: 'Размер шрифта',
              value: fontSize,
              min: 18,
              max: 30,
              divisions: 12,
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
              onChangeEnd: (value) =>
                  context.read<SettingsCubit>().changeFeedTitleFontSize(value),
            ),
            _FeedTitleSlider(
              label: 'Межстрочный интервал',
              value: fontHeight,
              min: 1,
              max: 1.5,
              divisions: 10,
              onChanged: (value) {
                setState(() {
                  _fontHeight = value;
                });
              },
              onChangeEnd: (value) => context
                  .read<SettingsCubit>()
                  .changeFeedTitleFontHeight(value),
            ),
            Padding(
              padding: const .symmetric(horizontal: 16.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.surfaceContainer,
                  borderRadius: .circular(8),
                ),
                child: Padding(
                  padding: const .all(12.0),
                  child: Text(
                    'Пример заголовка публикации в ленте',
                    style: previewStyle.copyWith(
                      fontSize: fontSize,
                      height: fontHeight,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _FeedTitleSlider extends StatefulWidget {
  const _FeedTitleSlider({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
    required this.onChangeEnd,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  @override
  State<_FeedTitleSlider> createState() => _FeedTitleSliderState();
}

class _FeedTitleSliderState extends State<_FeedTitleSlider> {
  late double value;

  @override
  void initState() {
    super.initState();

    value = widget.value;
  }

  @override
  void didUpdateWidget(covariant _FeedTitleSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      mainAxisSize: .min,
      children: [
        Padding(
          padding: const .only(left: 16.0, right: 16.0, top: 8.0),
          child: Text(
            '${widget.label}: ${value.toStringAsFixed(2)}',
            style: context.theme.textTheme.bodyMedium,
          ),
        ),
        Slider(
          label: widget.label,
          value: value,
          min: widget.min,
          max: widget.max,
          divisions: widget.divisions,
          onChanged: (newValue) {
            setState(() {
              value = newValue;
            });
            widget.onChanged(newValue);
          },
          onChangeEnd: widget.onChangeEnd,
        ),
      ],
    );
  }
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
