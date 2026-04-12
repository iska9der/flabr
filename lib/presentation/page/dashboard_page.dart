import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_cubit.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/settings/settings_cubit.dart';
import '../../core/component/router/router.dart';
import '../extension/extension.dart';
import '../widget/navigation/navigation.dart';

@RoutePage()
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    if (context.read<ProfileBloc>().state.status == .failure) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showProfileCorruptedAlert();
      });
    }
  }

  /// Если при загрузке профиля возникла ошибка, показываем уведомление
  /// об ошибке авторизации. Это может произойти, если при логине пришел
  /// некорректный connectSSID и [ProfileEvent.fetchMe] вернул null
  void showProfileCorruptedAlert() {
    context.showAlert(
      title: const Text('Ошибка авторизации'),
      content: const Text(
        'Возникли проблемы с полученым токеном\n\n'
        'Попробуйте перезайти в аккаунт, или игнорируйте '
        'это назойливое окно\n\n'
        'Может само пройдет? 🤔',
      ),
      actionsBuilder: (context) => [
        TextButton(
          onPressed: () {
            context.read<AuthCubit>().logOut();
            Navigator.of(context).pop();
          },
          child: const Text('Выйти из аккаунта'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationProvider(
      child: MultiBlocListener(
        listeners: [
          BlocListener<ProfileBloc, ProfileState>(
            listenWhen: (p, c) => p.status == .loading && c.status == .failure,
            listener: (context, state) => showProfileCorruptedAlert(),
          ),
        ],
        child: AutoTabsRouter(
          lazyLoad: false,
          routes: const [
            PublicationDashboardRoute(),
            ServicesFlowRoute(),
            SettingsRoute(),
          ],
          builder: (context, child) {
            final tabsRouter = context.tabsRouter;
            final navAlign = context
                .watch<SettingsCubit>()
                .state
                .misc
                .navigationAlignment;

            return Scaffold(
              floatingActionButtonLocation: BottomNavigation.getLocation(
                alignment: navAlign,
              ),
              floatingActionButton: BottomNavigation(router: tabsRouter),
              body: SafeArea(
                child: Row(
                  children: [
                    DrawerNavigation(router: tabsRouter),
                    Expanded(child: child),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
