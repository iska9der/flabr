import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/article_list_sliver.dart';
import '../../../component/di/dependencies.dart';
import '../../article/cubit/article_list_cubit.dart';
import '../../article/model/helper/article_list_source.dart';
import '../../article/repository/article_repository.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../settings/repository/language_repository.dart';
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
          create: (_) => ArticleListCubit(
            repository: getIt.get<ArticleRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
            source: ArticleListSource.userArticles,
            user: cubit.state.login,
          ),
        ),
        BlocProvider(
          create: (_) => ScrollCubit(),
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
        floatingActionButton: const FloatingScrollToTopButton(),
        body: Scrollbar(
          controller: scrollCtrl,
          child: CustomScrollView(
            controller: scrollCtrl,
            cacheExtent: 2000,
            slivers: const [
              ArticleListSliver(),
            ],
          ),
        ),
      ),
    );
  }
}
