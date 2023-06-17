import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../widget/button/common_floating_action_button.dart';
import '../../article/cubit/article_list_cubit.dart';
import '../../article/model/article_from_enum.dart';
import '../../article/page/article_list_page.dart';
import '../../article/repository/article_repository.dart';
import '../../scroll/cubit/scroll_cubit.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/user_cubit.dart';

@RoutePage(name: UserArticleListPage.routeName)
class UserArticleListPage extends StatelessWidget {
  const UserArticleListPage({super.key});

  static const String title = 'Публикации';
  static const String routePath = 'article';
  static const String routeName = 'UserArticleListRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserCubit>();

    return MultiBlocProvider(
      key: ValueKey('user-${cubit.state.login}-articles'),
      providers: [
        BlocProvider(
          create: (c) => ArticleListCubit(
            getIt.get<ArticleRepository>(),
            from: ArticleFromEnum.userArticles,
            user: cubit.state.login,
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit()..setUpEdgeListeners(),
        ),
      ],
      child: const UserArticleListPageView(),
    );
  }
}

class UserArticleListPageView extends StatelessWidget {
  const UserArticleListPageView({super.key});

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
            cacheExtent: 2000,
            slivers: const [
              ArticleSliverList(),
            ],
          ),
        ),
      ),
    );
  }
}
