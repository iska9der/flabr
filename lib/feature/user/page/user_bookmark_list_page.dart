import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../publication/repository/publication_repository.dart';
import '../../publication/widget/publication_sliver_list.dart';
import '../../settings/repository/language_repository.dart';
import '../cubit/user_bookmark_list_cubit.dart';
import '../cubit/user_cubit.dart';
import '../model/user_bookmarks_type.dart';
import '../widget/type_dropdown_widget.dart';

@RoutePage(name: UserBookmarkListPage.routeName)
class UserBookmarkListPage extends StatelessWidget {
  const UserBookmarkListPage({super.key, @PathParam() this.type = ''});

  final String type;

  static const String title = 'Закладки';
  static const String routePath = 'bookmarks/:type';
  static const String routeName = 'UserBookmarkListRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserCubit>();

    return MultiBlocProvider(
      key: ValueKey('user-${cubit.state.login}-bookmarks-$type'),
      providers: [
        BlocProvider(
          create: (_) => UserBookmarkListCubit(
            repository: getIt.get<PublicationRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
            user: cubit.state.login,
            type: UserBookmarksType.fromString(type),
          ),
        ),
        BlocProvider(
          create: (_) => ScrollCubit(),
        ),
      ],
      child: const UserBookmarkListView(),
    );
  }
}

class UserBookmarkListView extends StatelessWidget {
  const UserBookmarkListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scrollCtrl = context.read<ScrollCubit>().state.controller;

    return BlocListener<ScrollCubit, ScrollState>(
      listenWhen: (p, c) => c.isBottomEdge,
      listener: (c, state) => context.read<UserBookmarkListCubit>().fetch(),
      child: Scaffold(
        floatingActionButton: const FloatingScrollToTopButton(),
        body: Scrollbar(
          controller: scrollCtrl,
          child: CustomScrollView(
            controller: scrollCtrl,
            cacheExtent: 1000,
            slivers: [
              BlocBuilder<UserBookmarkListCubit, UserBookmarkListState>(
                builder: (context, state) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TypeDropdownMenu(
                        type: state.type.name,
                        onChanged: (type) => context
                            .read<UserBookmarkListCubit>()
                            .changeType(UserBookmarksType.fromString(type)),
                        entries: UserBookmarksType.values
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
              const PublicationSliverList<UserBookmarkListCubit,
                  UserBookmarkListState>(),
            ],
          ),
        ),
      ),
    );
  }
}
