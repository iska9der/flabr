import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../common/model/extension/state_status_x.dart';
import '../component/di/dependencies.dart';
import '../component/language.dart';
import '../config/constants.dart';
import '../feature/auth/cubit/auth_cubit.dart';
import '../feature/auth/cubit/login_cubit.dart';
import '../feature/auth/repository/auth_repository.dart';
import '../feature/auth/repository/token_repository.dart';
import '../feature/settings/cubit/settings_cubit.dart';
import '../feature/settings/widget/settings_card_widget.dart';
import '../feature/settings/widget/settings_checkbox_widget.dart';
import '../widget/image/full_image_widget.dart';

@RoutePage(name: 'SettingsRoute')
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
          'Аккаунт',
          style: textTheme.headlineMedium,
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8),
          child: ConnectSidWidget(),
        ),
        const SizedBox(height: hBetweenSub),
        Text(
          'Интерфейс',
          style: textTheme.headlineMedium,
        ),
        const UIThemeWidget(),
        const SizedBox(height: hBetweenSub),
        const UILangWidget(),
        const SizedBox(height: hBetweenSub),
        const ArticlesLangWidget(),
        const SizedBox(height: hBetweenSub),
        Text(
          'Лента',
          style: textTheme.headlineMedium,
        ),
        const SizedBox(height: hAfterHeadline),
        const SettingsFeedWidget(),
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
    return BlocProvider(
      create: (_) => LoginCubit(
        repository: getIt.get<AuthRepository>(),
        tokenRepository: getIt.get<TokenRepository>(),
      ),
      child: BlocListener<LoginCubit, LoginState>(
        listener: (_, state) {
          if (state.status.isSuccess) {
            context.read<AuthCubit>().handleAuthData();
          }
        },
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state.isAuthorized) {
              controller.text = state.data.connectSID;
            } else {
              controller.text = '';
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Если не удается войти через форму логина'),
                const SizedBox(height: 14),
                TextFormField(
                  enabled: !state.isAuthorized,
                  controller: controller,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    label: Text('Connect SID'),
                    hintText: 'Можно найти в cookies',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    state.isAuthorized
                        ? ElevatedButton(
                            onPressed: () => context.read<AuthCubit>().logOut(),
                            child: const Text('Очистить'),
                          )
                        : FilledButton(
                            onPressed: () =>
                                context.read<LoginCubit>().submitConnectSid(
                                      controller.text,
                                    ),
                            child: const Text('Сохранить'),
                          ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) {
                          return const FullAssetImageWidget(
                            assetPath: 'assets/connect_sid_instruction.gif',
                          );
                        },
                      ),
                      child: const Text('Инструкция'),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class UIThemeWidget extends StatefulWidget {
  const UIThemeWidget({Key? key}) : super(key: key);

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
