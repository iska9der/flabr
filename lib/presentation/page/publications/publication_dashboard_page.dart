import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/component/di/injector.dart';
import '../../../core/component/router/app_router.dart';
import '../../feature/auth/cubit/auth_cubit.dart';
import '../../feature/auth/widget/profile_icon_button.dart';
import '../../theme/part.dart';
import '../../widget/dashboard_drawer_link_widget.dart';
import 'bloc/publication_counters_bloc.dart';

@RoutePage(name: PublicationDashboardPage.routeName)
class PublicationDashboardPage extends StatefulWidget {
  const PublicationDashboardPage({super.key});

  static const String routePath = '';
  static const String routeName = 'PublicationDashboardRoute';

  @override
  State<PublicationDashboardPage> createState() =>
      _PublicationDashboardPageState();
}

class _PublicationDashboardPageState extends State<PublicationDashboardPage> {
  late final PublicationCountersBloc countersBloc;
  late final StreamSubscription authSub;

  /// Прячем табы когда мы не находимся в корне раздела "Публикации".
  /// Если не прятать, то когда мы переходим на какой-нибудь экран с помощью роутера
  /// это выглядит ущербно и занимает лишнее место сверху экрана
  ScrollPhysics? tabBarPhysics;

  @override
  void initState() {
    countersBloc = PublicationCountersBloc(repository: getIt());
    authSub = context.read<AuthCubit>().stream.listen((state) {
      if (state.isAuthorized || state.isUnauthorized) {
        countersBloc.add(const PublicationCountersEvent.load());
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    authSub.cancel();
    countersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      physics: tabBarPhysics,
      routes: const [
        FeedRouter(),
        ArticlesRouter(),
        PostsRouter(),
        NewsRouter(),
      ],
      builder: (context, child, controller) {
        return Column(
          children: [
            SizedBox(
              height: fDashboardTabHeight,
              child: ColoredBox(
                color: Theme.of(context).colorScheme.surface,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: BlocBuilder<PublicationCountersBloc,
                          PublicationCountersState>(
                        bloc: countersBloc,
                        builder: (context, state) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: TabBar(
                              controller: controller,
                              isScrollable: true,
                              padding: EdgeInsets.zero,
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              dividerColor: Colors.transparent,
                              tabs: [
                                const DashboardDrawerLinkWidget(
                                  title: 'Моя лента',
                                ),
                                DashboardDrawerLinkWidget(
                                  title: 'Статьи',
                                  count: state.counters.articles,
                                ),
                                DashboardDrawerLinkWidget(
                                  title: 'Посты',
                                  count: state.counters.posts,
                                ),
                                DashboardDrawerLinkWidget(
                                  title: 'Новости',
                                  count: state.counters.news,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.search_rounded),
                          onPressed: () => getIt<AppRouter>().push(
                            const SearchAnywhereRoute(),
                          ),
                        ),
                        const MyProfileIconButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: child),
          ],
        );
      },
    );
  }
}
