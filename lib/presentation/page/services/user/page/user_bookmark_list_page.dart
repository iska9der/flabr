import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../data/model/user/user_bookmarks_type.dart';
import '../../../../feature/scroll/part.dart';
import '../../../../widget/publication_sliver_list.dart';
import '../cubit/user_bookmark_list_cubit.dart';
import '../cubit/user_comment_list_cubit.dart';
import '../cubit/user_cubit.dart';
import '../widget/comment_sliver_list.dart';
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
    final alias = cubit.state.login;

    return MultiBlocProvider(
      key: ValueKey('user-$alias-bookmarks-$type'),
      providers: [
        BlocProvider(
          create: (_) => UserBookmarkListCubit(
            repository: getIt(),
            languageRepository: getIt(),
            user: alias,
            type: UserBookmarksType.fromString(type),
          ),
        ),
        BlocProvider(
          create: (_) => UserCommentListCubit(
            repository: getIt(),
            user: alias,
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

    return Scaffold(
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
            BlocBuilder<UserBookmarkListCubit, UserBookmarkListState>(
              builder: (context, state) {
                return switch (state.type) {
                  UserBookmarksType.comments =>
                    BlocListener<ScrollCubit, ScrollState>(
                      listenWhen: (p, c) => c.isBottomEdge,
                      listener: (c, state) =>
                          context.read<UserCommentListCubit>().fetchBookmarks(),
                      child: CommentSliverList(
                        fetch:
                            context.read<UserCommentListCubit>().fetchBookmarks,
                      ),
                    ),
                  _ => BlocListener<ScrollCubit, ScrollState>(
                      listenWhen: (p, c) => c.isBottomEdge,
                      listener: (c, state) =>
                          context.read<UserBookmarkListCubit>().fetch(),
                      child: const PublicationSliverList<UserBookmarkListCubit,
                          UserBookmarkListState>(),
                    ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}