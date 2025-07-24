import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/settings/settings_cubit.dart';
import '../../../../bloc/user/user_publication_list_cubit.dart';
import '../../../../data/model/user/user.dart';
import '../../../../di/di.dart';
import '../../../../feature/publication_list/publication_list.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../widget/enhancement/refresh_indicator.dart';
import 'widget/type_dropdown_widget.dart';

@RoutePage(name: UserPublicationListPage.routeName)
class UserPublicationListPage extends StatelessWidget {
  const UserPublicationListPage({
    super.key,
    @PathParam.inherit('alias') required this.alias,
    @PathParam() this.type = '',
  });

  final String alias;
  final String type;

  static const String title = 'Публикации';
  static const String routePath = 'publications/:type';
  static const String routeName = 'UserPublicationListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('user-$alias-publications-$type'),
      providers: [
        BlocProvider(
          create:
              (_) => UserPublicationListCubit(
                repository: getIt(),
                languageRepository: getIt(),
                user: alias,
                type: UserPublicationType.fromString(type),
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
    final scrollCubit = context.read<ScrollCubit>();
    final scrollCtrl = scrollCubit.state.controller;
    final scrollPhysics = context.select<SettingsCubit, ScrollPhysics>(
      (value) => value.state.misc.scrollVariant.physics(context),
    );

    return BlocListener<ScrollCubit, ScrollState>(
      listenWhen: (p, c) => c.isBottomEdge,
      listener: (c, state) => context.read<UserPublicationListCubit>().fetch(),
      child: Scaffold(
        floatingActionButton: const FloatingScrollToTopButton(),
        body: Scrollbar(
          controller: scrollCtrl,
          child: CustomScrollView(
            controller: scrollCtrl,
            cacheExtent: 2000,
            physics: scrollPhysics,
            slivers: [
              FlabrSliverRefreshIndicator(
                onRefresh: context.read<UserPublicationListCubit>().reset,
              ),
              BlocBuilder<UserPublicationListCubit, UserPublicationListState>(
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TypeDropdownMenu(
                        type: state.type.name,
                        onChanged:
                            (type) => context
                                .read<UserPublicationListCubit>()
                                .changeType(
                                  UserPublicationType.fromString(type),
                                ),
                        entries:
                            UserPublicationType.values
                                .map(
                                  (type) => DropdownMenuItem(
                                    value: type.name,
                                    child: Text(type.label),
                                  ),
                                )
                                .toList(),
                      ),
                    ),
                  );
                },
              ),
              const PublicationSliverList<
                UserPublicationListCubit,
                UserPublicationListState
              >(),
            ],
          ),
        ),
      ),
    );
  }
}
