import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ya_summary/ya_summary.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../bloc/profile/profile_bloc.dart';
import '../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../bloc/settings/settings_cubit.dart';
import '../../../di/di.dart';

/// Предоставляет глобальные BLoC провайдеры для всего приложения.
///
/// Этот виджет создает и управляет следующими BLoCs:
/// - [SettingsCubit] - настройки приложения (тема, язык, и т.д.)
/// - [AuthCubit] - состояние авторизации пользователя
/// - [SummaryAuthCubit] - авторизация для YandexGPT сервиса
/// - [ProfileBloc] - профиль текущего пользователя
/// - [PublicationBookmarksBloc] - закладки публикаций (lazy loaded)
class GlobalBlocProvider extends StatelessWidget {
  const GlobalBlocProvider({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Основные настройки и конфигурация
        BlocProvider.value(value: getIt<SettingsCubit>()),

        /// Авторизация
        BlocProvider(
          lazy: false,
          create: (_) => AuthCubit(tokenRepository: getIt()),
        ),

        /// Генерация коротких пересказов
        BlocProvider(
          lazy: false,
          create: (_) => SummaryAuthCubit(tokenRepository: getIt()),
        ),

        /// Профиль пользователя
        BlocProvider(
          lazy: false,
          create: (_) => ProfileBloc(repository: getIt()),
        ),

        /// Функции публикаций (загружаются по требованию)
        BlocProvider(
          create: (_) =>
              PublicationBookmarksBloc(logger: getIt(), repository: getIt()),
        ),
      ],
      child: child,
    );
  }
}
