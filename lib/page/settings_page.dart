import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/model/extension/enum_status.dart';
import '../common/utils/utils.dart';
import '../common/widget/article_settings_widget.dart';
import '../component/di/dependencies.dart';
import '../component/language.dart';
import '../config/constants.dart';
import '../feature/auth/cubit/auth_cubit.dart';
import '../feature/auth/cubit/login_cubit.dart';
import '../feature/auth/repository/token_repository.dart';
import '../feature/settings/cubit/settings_cubit.dart';
import '../feature/settings/widget/settings_card_widget.dart';
import '../feature/settings/widget/settings_checkbox_widget.dart';
import '../feature/settings/widget/settings_section_widget.dart';

@RoutePage(name: 'SettingsRoute')
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: SettingsView()),
    );
  }
}

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: kScreenHPadding),
      children: const [
        SettingsSectionWidget(
          title: 'Аккаунт',
          children: [
            ConnectSidWidget(),
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
          ],
        ),
        SettingsSectionWidget(
          title: 'Статьи',
          children: [
            SettingsCardWidget(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ArticleSettingsWidget(),
            ),
          ],
        ),
      ],
    );
  }
}

class ConnectSidWidget extends StatefulWidget {
  const ConnectSidWidget({super.key});

  @override
  State<ConnectSidWidget> createState() => _ConnectSidWidgetState();
}

class _ConnectSidWidgetState extends State<ConnectSidWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();

    return BlocProvider(
      create: (_) => LoginCubit(
        tokenRepository: getIt.get<TokenRepository>(),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listenWhen: (previous, current) => current.status.isSuccess,
        listener: (_, state) => authCubit.handleAuthData(),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final loginCubit = context.read<LoginCubit>();

            if (state.isAuthorized) {
              controller.text = state.data.connectSID;
            } else {
              controller.text = '';
            }

            return SettingsCardWidget(
              title: 'Connect SID',
              subtitle: 'Если не удается войти через форму логина',
              padding: const EdgeInsets.all(6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    enabled: !state.isAuthorized,
                    controller: controller,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: 'Можно найти в cookies',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      state.isAuthorized
                          ? ElevatedButton(
                              onPressed: () {
                                authCubit.logOut();
                              },
                              child: const Text('Очистить'),
                            )
                          : FilledButton(
                              onPressed: () {
                                loginCubit.submitConnectSid(controller.text);
                              },
                              child: const Text('Сохранить'),
                            ),
                      const SizedBox(width: 12),
                      if (state.isAuthorized)
                        ElevatedButton(
                          onPressed: () {
                            Clipboard.setData(
                              ClipboardData(text: controller.text),
                            );
                            getIt.get<Utils>().showNotification(
                                  context: context,
                                  content: const Text(
                                    'Скопировано в буфер обмена',
                                  ),
                                );
                          },
                          child: const Text('Скопировать'),
                        ),
                    ],
                  ),
                ],
              ),
            );
          },
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
    isDarkTheme = context.read<SettingsCubit>().state.isDarkTheme;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCardWidget(
      title: 'Цветовая схема',
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SwitchListTile.adaptive(
        title: const Text('Темная тема'),
        contentPadding: EdgeInsets.zero,
        value: isDarkTheme,
        onChanged: isLoading
            ? null
            : (val) {
                setState(() {
                  isDarkTheme = val;
                  isLoading = true;
                });

                Future.delayed(const Duration(milliseconds: 300), () {
                  context.read<SettingsCubit>().changeTheme(isDarkTheme: val);
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
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
            children: LanguageEnum.values
                .map(
                  (lang) => SettingsCheckboxWidget(
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
            initialValue: settingsCubit.state.feedConfig.isImageVisible,
            title: const Text('Изображения'),
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
