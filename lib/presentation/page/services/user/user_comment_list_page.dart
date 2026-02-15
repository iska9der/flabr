import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/settings/settings_cubit.dart';
import '../../../../bloc/user/user_comment_list_cubit.dart';
import '../../../../di/di.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../widget/enhancement/refresh_indicator.dart';
import 'widget/comment_sliver_list.dart';

@RoutePage(name: UserCommentListPage.routeName)
class UserCommentListPage extends StatelessWidget {
  const UserCommentListPage({
    super.key,
    @PathParam.inherit('alias') required this.alias,
  });

  final String alias;

  static const String title = 'Комментарии';
  static const String routePath = 'comments';
  static const String routeName = 'UserCommentListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('user-$alias-comments'),
      providers: [
        BlocProvider(
          create: (_) => UserCommentListCubit(repository: getIt(), user: alias),
        ),
        BlocProvider(create: (_) => ScrollCubit()),
      ],
      child: const _UserCommentListView(),
    );
  }
}

class _UserCommentListView extends StatelessWidget {
  // ignore: unused_element_parameter
  const _UserCommentListView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit>();
    final scrollCtrl = scrollCubit.controller;
    final scrollPhysics = context.select<SettingsCubit, ScrollPhysics>(
      (value) => value.state.misc.scrollVariant.physics(context),
    );

    return BlocListener<ScrollCubit, ScrollState>(
      listenWhen: (p, c) => c.isBottomEdge,
      listener: (c, state) => context.read<UserCommentListCubit>().fetch(),
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
                onRefresh: context.read<UserCommentListCubit>().reset,
              ),
              CommentSliverList(
                fetch: context.read<UserCommentListCubit>().fetch,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
