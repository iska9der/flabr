import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/profile/profile_bloc.dart';
import '../../../../bloc/user/user_cubit.dart';
import '../../../../core/component/router/app_router.dart';
import '../../../../data/model/loading_status_enum.dart';
import '../../../../di/di.dart';
import '../../../../feature/scaffold/scaffold.dart';
import '../../../theme/theme.dart';
import '../../../widget/dashboard_drawer_link_widget.dart';
import '../../../widget/enhancement/enhancement.dart';
import 'user_bookmark_list_page.dart';
import 'user_comment_list_page.dart';
import 'user_detail_page.dart';
import 'user_publication_list_page.dart';

/// Роут используется, когда нам нужно отобразить собственный профиль,
/// но нам пока неизвестен alias пользователя.
/// Поэтому для начала мы грузим информацию, и затем редиректим
/// на [UserDashboardPage]
@RoutePage()
class ProfileDashboardPage extends StatelessWidget {
  const ProfileDashboardPage({super.key});

  static const String routePath = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.status == LoadingStatus.initial) {
            context.read<ProfileBloc>().add(const ProfileEvent.fetchMe());
          }

          /// Успешно загрузились, пора редиректить
          if (state.status == LoadingStatus.success && !state.me.isEmpty) {
            /// Вытаскиваем путь, по которому мы его кидали
            final newRoutes = context.router.current.pendingChildren
                .map((e) => e.toPageRouteInfo())
                .toList();

            SchedulerBinding.instance.addPostFrameCallback(
              (_) {
                /// Закрываем этот экран и отдаем новый
                context.router
                  ..pop()
                  ..push(
                    UserDashboardRoute(
                      alias: state.me.alias,
                      children: newRoutes,
                    ),
                  );
              },
            );
          }

          if (state.status == LoadingStatus.failure) {
            return const Center(
              child: Text('Не удалось загрузить ваш профиль'),
            );
          }

          return const CircleIndicator();
        },
      ),
    );
  }
}

@RoutePage()
class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({super.key, @PathParam() required this.alias});

  final String alias;

  static const String routePath = 'users/:alias';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey('user-$alias-dashboard'),
          lazy: false,
          create: (_) => UserCubit(alias, repository: getIt()),
        ),
        BlocProvider(create: (_) => ScaffoldCubit()),
      ],
      child: const UserDashboardView(),
    );
  }
}

class UserDashboardView extends StatelessWidget {
  const UserDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final userCubit = context.read<UserCubit>();

    return AutoTabsRouter.tabBar(
      routes: [
        UserDetailRoute(),
        UserPublicationListRoute(),
        UserCommentListRoute(),
        UserBookmarkListRoute(),
      ],
      builder: (context, child, controller) {
        return Scaffold(
          key: context.read<ScaffoldCubit>().key,
          appBar: AppBar(
            title: Text(userCubit.state.login),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(AppDimensions.tabBarHeight),
              child: SizedBox(
                height: AppDimensions.tabBarHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: controller,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      DashboardDrawerLinkWidget(title: UserDetailPage.title),
                      DashboardDrawerLinkWidget(
                        title: UserPublicationListPage.title,
                      ),
                      DashboardDrawerLinkWidget(
                        title: UserCommentListPage.title,
                      ),
                      DashboardDrawerLinkWidget(
                        title: UserBookmarkListPage.title,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(child: child),
        );
      },
    );
  }
}
