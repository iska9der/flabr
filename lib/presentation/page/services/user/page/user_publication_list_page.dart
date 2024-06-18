import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../data/model/user/user_publication_type.dart';
import '../../../../feature/publication_list/part.dart';
import '../../../../feature/scroll/part.dart';
import '../../../../widget/enhancement/refresh_indicator.dart';
import '../cubit/user_publication_list_cubit.dart';
import '../widget/type_dropdown_widget.dart';

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
          create: (_) => UserPublicationListCubit(
            repository: getIt(),
            languageRepository: getIt(),
            user: alias,
            type: UserPublicationType.fromString(type),
          ),
        ),
        BlocProvider(
          create: (_) => ScrollCubit(),
        ),
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
            physics: scrollCubit.physics,
            slivers: [
              FlabrSliverRefreshIndicator(
                onRefresh: context.read<UserPublicationListCubit>().refetch,
              ),
              BlocBuilder<UserPublicationListCubit, UserPublicationListState>(
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TypeDropdownMenu(
                        type: state.type.name,
                        onChanged: (type) => context
                            .read<UserPublicationListCubit>()
                            .changeType(UserPublicationType.fromString(type)),
                        entries: UserPublicationType.values
                            .map((type) => DropdownMenuItem(
                                  value: type.name,
                                  child: Text(type.label),
                                ))
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
              const PublicationSliverList<UserPublicationListCubit,
                  UserPublicationListState>(),
            ],
          ),
        ),
      ),
    );
  }
}
