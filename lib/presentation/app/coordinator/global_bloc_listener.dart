import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../core/component/shortcuts/shortcuts.dart';
import '../../../di/di.dart';

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
        /// Когда пользователь входит в аккаунт, загружаем профиль и обновления.
        /// При выходе сбрасываем состояние профиля.
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            final profileBloc = context.read<ProfileBloc>();

            switch (state.status) {
              case AuthStatus.authorized:
                profileBloc.add(const ProfileEvent.fetchMe());
                profileBloc.add(const ProfileEvent.fetchUpdates());
              case AuthStatus.unauthorized:
                profileBloc.add(const ProfileEvent.reset());
              default:
                break;
            }
          },
        ),

        /// Инициализируем и обновляем ярлыки быстрого доступа.
        /// Срабатывает при старте (current.me.isEmpty) и при изменении профиля.
        BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (previous, current) =>
              previous.me != current.me || current.me.isEmpty,
          listener: (context, state) {
            getIt<ShortcutsManager>().init(state.me);
          },
        ),
      ],
      child: child,
    );
  }
}
