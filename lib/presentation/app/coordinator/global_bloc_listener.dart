import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../bloc/settings/settings_cubit.dart';
import '../../../core/component/shortcuts/shortcuts.dart';
import '../../../di/di.dart';
import '../../../i18n/i18n.dart';

/// Предоставляет глобальные BLoC listeners для всего приложения.
///
/// Централизует всю координационную логику между BLoCs на уровне приложения.
class GlobalBlocListener extends StatelessWidget {
  const GlobalBlocListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        /// Синхронизируем сохраненный язык со Slang, Intl и ярлыками
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.langUI != current.langUI ||
              previous.status != current.status && current.status == .success,
          listener: (context, state) {
            LocaleSettings.setLocaleSync(state.langUI.appLocale);
            Intl.defaultLocale = state.langUI.locale.toString();

            unawaited(
              getIt<ShortcutsManager>().createShortcuts(
                isAuthorized: !context.read<ProfileBloc>().state.me.isEmpty,
              ),
            );
          },
        ),

        /// Когда пользователь входит в аккаунт, загружаем профиль и обновления.
        /// При выходе сбрасываем состояние профиля.
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthStatus.authorized:
                context.read<ProfileBloc>()
                  ..add(const .fetchMe())
                  ..add(const .fetchUpdates());
              case AuthStatus.unauthorized:
                context.read<ProfileBloc>().add(const .reset());
              default:
                break;
            }
          },
        ),

        /// Задаем ярлыки быстрого доступа.
        /// Срабатывает при старте (current.me.isEmpty) и при изменении профиля.
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.me != current.me || current.me.isEmpty,
          listener: (context, state) {
            unawaited(
              getIt<ShortcutsManager>().createShortcuts(
                isAuthorized: !state.me.isEmpty,
              ),
            );
          },
        ),
      ],
      child: child,
    );
  }
}
