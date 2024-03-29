import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/publication_sliver_list.dart';
import '../../../component/di/dependencies.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../publication/repository/publication_repository.dart';
import '../../settings/repository/language_repository.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_publication_list_cubit.dart';
import '../model/user_publication_type.dart';
import '../widget/type_dropdown_widget.dart';

@RoutePage(name: UserPublicationListPage.routeName)
class UserPublicationListPage extends StatelessWidget {
  const UserPublicationListPage({super.key, @PathParam() this.type = ''});

  final String type;

  static const String title = 'Публикации';
  static const String routePath = 'publications/:type';
  static const String routeName = 'UserPublicationListRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserCubit>();

    return MultiBlocProvider(
      key: ValueKey('user-${cubit.state.login}-publications-$type'),
      providers: [
        BlocProvider(
          create: (_) => UserPublicationListCubit(
            repository: getIt.get<PublicationRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
            user: cubit.state.login,
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
    final scrollCtrl = context.read<ScrollCubit>().state.controller;

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
            slivers: [
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
