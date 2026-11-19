import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../bloc/settings/settings_cubit.dart';
import '../../../../bloc/user/user_publication_list_cubit.dart';
import '../../../../di/di.dart';
import '../../../../feature/publication_list/publication_list.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../theme/theme.dart';
import '../../../widget/enhancement/refresh_indicator.dart';
import '../../../widget/navigation/navigation.dart';

@RoutePage(name: UserPublicationListPage.routeName)
class UserPublicationListPage extends StatelessWidget {
  const UserPublicationListPage({
    super.key,
    @PathParam.inherit('alias') required this.alias,
  });

  final String alias;

  static const String routePath = 'publications';
  static const String routeName = 'UserPublicationListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('user-$alias-publications'),
      providers: [
        BlocProvider(
          create: (_) => UserPublicationListCubit(
            repository: getIt(),
            languageRepository: getIt(),
            settingsRepository: getIt(),
            user: alias,
          ),
        ),
        BlocProvider(create: (_) => ScrollCubit()),
      ],
      child: const UserPublicationListView(),
    );
  }
}

class UserPublicationListView extends StatelessWidget {
  const UserPublicationListView({super.key});

  @override
  Widget build(BuildContext context) {
    final listCubit = context.read<UserPublicationListCubit>();
    final scrollCubit = context.read<ScrollCubit>();
    final scrollCtrl = scrollCubit.controller;
    final scrollPhysics = context.select<SettingsCubit, ScrollPhysics>(
      (value) => value.state.misc.scrollVariant.physics(context),
    );

    return BlocListener<ScrollCubit, ScrollState>(
      listenWhen: (p, c) => c.isBottomEdge,
      listener: (context, state) {
        if (context.read<SettingsCubit>().state.feed.navigationMode ==
            .infiniteScroll) {
          listCubit.fetch();
        }
      },
      child: Scaffold(
        floatingActionButton: const FloatingContainer(
          children: [FloatingScrollToTopButton()],
        ),
        body: Scrollbar(
          controller: scrollCtrl,
          child: CustomScrollView(
            controller: scrollCtrl,
            scrollCacheExtent: const .pixels(2000),
            physics: scrollPhysics,
            slivers: [
              FlabrSliverRefreshIndicator(onRefresh: listCubit.refresh),
              SliverPadding(
                padding: AppInsets.screenExtended,
                sliver: PublicationSliverList(bloc: listCubit),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
