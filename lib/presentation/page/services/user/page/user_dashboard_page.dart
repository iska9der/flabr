import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../core/component/router/app_router.dart';
import '../../../../feature/scaffold/part.dart';
import '../../../../theme/part.dart';
import '../../../../widget/dashboard_drawer_link_widget.dart';
import '../cubit/user_cubit.dart';
import 'user_bookmark_list_page.dart';
import 'user_comment_list_page.dart';
import 'user_detail_page.dart';
import 'user_publication_list_page.dart';

@RoutePage(name: UserDashboardPage.routeName)
class UserDashboardPage extends StatelessWidget {
  const UserDashboardPage({
    super.key,
    @PathParam() required this.alias,
  });

  final String alias;

  static const String routePath = 'users/:alias';
  static const String routeName = 'UserDashboardRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          key: ValueKey('user-$alias-dashboard'),
          lazy: false,
          create: (_) => UserCubit(
            alias,
            repository: getIt(),
            languageRepository: getIt(),
          ),
        ),
        BlocProvider(
          create: (_) => ScaffoldCubit(),
        ),
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
              preferredSize: const Size.fromHeight(fDashboardTabHeight),
              child: SizedBox(
                height: fDashboardTabHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TabBar(
                    controller: controller,
                    isScrollable: true,
                    padding: EdgeInsets.zero,
                    dividerColor: Colors.transparent,
                    tabs: const [
                      DashboardDrawerLinkWidget(
                        title: UserDetailPage.title,
                        route: UserDetailPage.routePath,
                      ),
                      DashboardDrawerLinkWidget(
                        title: UserPublicationListPage.title,
                        route: UserPublicationListPage.routePath,
                      ),
                      DashboardDrawerLinkWidget(
                        title: UserCommentListPage.title,
                        route: UserCommentListPage.routePath,
                      ),
                      DashboardDrawerLinkWidget(
                        title: UserBookmarkListPage.title,
                        route: UserBookmarkListPage.routePath,
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
