import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ya_summary/ya_summary.dart';

import '../core/component/di/di.dart';
import '../core/component/router/app_router.dart';
import '../feature/auth/auth.dart';
import 'extension/extension.dart';
import 'page/settings/cubit/settings_cubit.dart';
import 'theme/theme.dart';
import 'widget/enhancement/progress_indicator.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final AppRouter router;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create:
              (_) => SettingsCubit(
                languageRepository: getIt(),
                storage: getIt(instanceName: 'sharedStorage'),
              )..init(),
        ),
        BlocProvider(
          lazy: false,
          create:
              (_) =>
                  AuthCubit(repository: getIt(), tokenRepository: getIt())
                    ..init(),
        ),
        BlocProvider(
          lazy: false,
          create: (_) => SummaryAuthCubit(tokenRepository: getIt())..init(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen:
                (previous, current) =>
                    previous.status.isLoading && current.isAuthorized,
            listener: (context, _) {
              context.read<AuthCubit>().fetchMe();
              context.read<AuthCubit>().fetchUpdates();
            },
          ),
        ],
        child: BlocBuilder<SettingsCubit, SettingsState>(
          builder: (context, state) {
            if (state.status == SettingsStatus.loading) {
              /// TODO: Splash Page
              return const Material(child: CircleIndicator());
            }

            return Listener(
              onPointerDown: (_) {
                // FocusScopeNode currentFocus = FocusScope.of(context);
                // if (!currentFocus.hasPrimaryFocus) {
                //   currentFocus.focusedChild?.unfocus();
                // }
              },
              child: MaterialApp.router(
                title: 'Flabr',
                // ignore: deprecated_member_use
                useInheritedMediaQuery: true,
                locale: DevicePreview.locale(context),
                themeMode: state.theme.modeByBool ?? state.theme.mode,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                scrollBehavior: state.misc.scrollVariant.behavior,
                routerConfig: router.config(
                  deepLinkTransformer: (uri) {
                    if (uri.path.startsWith('/ru')) {
                      final newPath = uri.path.replaceFirst('/ru', '');
                      return SynchronousFuture(uri.replace(path: newPath));
                    }
                    return SynchronousFuture(uri);
                  },
                ),
                builder: (context, child) {
                  return DevicePreview.appBuilder(
                    context,
                    ResponsiveBreakpoints.builder(
                      child: child ?? const SizedBox.shrink(),
                      breakpoints: [
                        const Breakpoint(
                          start: 0,
                          end: 600,
                          name: ScreenType.mobile,
                        ),
                        const Breakpoint(
                          start: 601,
                          end: 840,
                          name: ScreenType.tablet,
                        ),
                        const Breakpoint(
                          start: 841,
                          end: double.infinity,
                          name: ScreenType.desktop,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
