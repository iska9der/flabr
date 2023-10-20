import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../widget/button/common_floating_action_button.dart';
import '../../article/cubit/article_list_cubit.dart';
import '../../article/model/article_from_enum.dart';
import '../../article/page/article_list_page.dart';
import '../../article/repository/article_repository.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/user_cubit.dart';

@RoutePage(name: UserBookmarkListPage.routeName)
class UserBookmarkListPage extends StatelessWidget {
  const UserBookmarkListPage({super.key});

  static const String title = 'Закладки';
  static const String routePath = 'bookmarks';
  static const String routeName = 'UserBookmarkListRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserCubit>();

    return MultiBlocProvider(
      key: ValueKey('user-${cubit.state.login}-bookmarks'),
      providers: [
        BlocProvider(
          create: (c) => ArticleListCubit(
            getIt.get<ArticleRepository>(),
            from: ArticleFromEnum.userBookmarks,
            user: cubit.state.login,
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit(),
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
    final articlesCubit = context.read<ArticleListCubit>();
    final scrollCtrl = context.read<ScrollCubit>().state.controller;

    return BlocListener<ScrollCubit, ScrollState>(
      listenWhen: (p, c) => c.isBottomEdge,
      listener: (c, state) => articlesCubit.fetch(),
      child: Scaffold(
        floatingActionButton: const CommonFloatingActionButton(),
        floatingActionButtonLocation: CommonFloatingActionButton.location,
        body: Scrollbar(
          controller: scrollCtrl,
          child: CustomScrollView(
            controller: scrollCtrl,
            cacheExtent: 1000,
            slivers: const [
              ArticleSliverList(),
            ],
          ),
        ),
      ),
    );
  }
}
