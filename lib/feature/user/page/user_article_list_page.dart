import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../article/cubit/article_list_cubit.dart';
import '../../article/model/article_from_enum.dart';
import '../../article/page/article_list_page.dart';
import '../../article/service/article_service.dart';
import '../../scroll/cubit/scroll_cubit.dart';
import '../../scroll/widget/floating_scroll_to_top_button.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/user_cubit.dart';

class UserArticleListPage extends StatelessWidget {
  const UserArticleListPage({Key? key}) : super(key: key);

  static const String title = 'Публикации';
  static const String routePath = 'article';
  static const String routeName = 'UserArticleListRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserCubit>();

    return MultiBlocProvider(
      key: ValueKey('user-${cubit.state.login}-article'),
      providers: [
        BlocProvider(
          create: (c) => ArticleListCubit(
            getIt.get<ArticleService>(),
            from: ArticleFromEnum.user,
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
  const UserArticleListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final articlesCubit = context.read<ArticleListCubit>();
    final scrollCtrl = context.read<ScrollCubit>().state.controller;

    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (p, c) => c.isBottomEdge,
          listener: (c, state) => articlesCubit.fetch(),
        ),

        /// Листенер на смену языков в публикациях пользователя не нужен,
        /// так как это не влияет на вывод
      ],
      child: Scaffold(
        floatingActionButton: const FloatingScrollToTopButton(),
        body: Scrollbar(
          controller: scrollCtrl,
          child: CustomScrollView(
            controller: scrollCtrl,
            cacheExtent: 5000,
            slivers: const [
              ArticleSliverList(),
            ],
          ),
        ),
      ),
    );
  }
}
