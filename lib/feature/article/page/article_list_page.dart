import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widget/article_list_sliver.dart';
import '../../../common/widget/button/floating_buttons.dart';
import '../../../component/di/dependencies.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../enhancement/scaffold/cubit/scaffold_cubit.dart';
import '../../enhancement/scroll/cubit/scroll_cubit.dart';
import '../../search/cubit/search_cubit.dart';
import '../../search/repository/search_repository.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/article_list_cubit.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../repository/article_repository.dart';
import '../widget/article_list/article_list_appbar.dart';
import '../widget/article_list/article_list_drawer.dart';

@RoutePage(name: ArticleListPage.routeName)
class ArticleListPage extends StatelessWidget {
  const ArticleListPage({super.key, @PathParam() required this.flow});

  final String flow;

  static const String name = 'Статьи';
  static const String routePath = 'flows/:flow';
  static const String routeName = 'ArticleListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('articles-$flow-flow'),
      providers: [
        BlocProvider(
          create: (c) => ArticleListCubit(
            getIt.get<ArticleRepository>(),
            flow: FlowEnum.fromString(flow),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => SearchCubit(
            getIt.get<SearchRepository>(),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit(),
        ),
        BlocProvider(
          create: (c) => ScaffoldCubit(),
        ),
      ],
      child: const ArticleListView(),
    );
  }
}

class ArticleListView extends StatelessWidget {
  const ArticleListView({
    super.key,
    this.type = ArticleType.article,
  });

  final ArticleType type;

  @override
  Widget build(BuildContext context) {
    final articlesCubit = context.read<ArticleListCubit>();
    final scrollCubit = context.read<ScrollCubit>();
    final scrollController = scrollCubit.state.controller;

    return MultiBlocListener(
      listeners: [
        /// Выводим снэкбар об ошибке, если возникла ошибка при получении
        /// данных о вошедшем юзере. Ошибка возникает, если при логине
        /// пришел некорректный connectSSID и [AuthCubit.fetchMe()]
        /// вернул null
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.isAuthorized && c.isAnomaly,
          listener: (c, state) {
            getIt.get<Utils>().showNotification(
                  context: context,
                  content: const Text(
                    'Возникла неизвестная ошибка при авторизации',
                  ),
                  action: SnackBarAction(
                    label: 'Выйти',
                    onPressed: () => context.read<AuthCubit>().logOut(),
                  ),
                  duration: const Duration(seconds: 5),
                );
          },
        ),

        /// Если пользователь вошел, надо переполучить статьи
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.status.isLoading && c.isAuthorized,
          listener: (context, state) {
            articlesCubit.refetch();
          },
        ),

        /// Если пользователь вышел
        ///
        /// к тому же он находится в потоке "Моя лента", то отправляем его
        /// на поток "Все", виджет сам стриггерит получение статей
        ///
        /// иначе переполучаем статьи напрямую
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.status.isLoading && c.isUnauthorized,
          listener: (context, state) {
            if (articlesCubit.state.flow == FlowEnum.feed) {
              return articlesCubit.changeFlow(FlowEnum.all);
            }

            articlesCubit.refetch();
          },
        ),

        /// Смена языков
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (p, c) =>
              p.langUI != c.langUI || p.langArticles != c.langArticles,
          listener: (context, state) {
            articlesCubit.changeLanguage(
              langUI: state.langUI,
              langArticles: state.langArticles,
            );

            scrollCubit.animateToTop();
          },
        ),

        /// Когда скролл достиг предела, получаем следующую страницу
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (p, c) => c.isBottomEdge,
          listener: (c, state) => articlesCubit.fetch(),
        ),
      ],
      child: Scaffold(
        key: context.read<ScaffoldCubit>().key,
        drawer: ArticleListDrawer(type: type),
        floatingActionButton: const FloatingButtons(),
        floatingActionButtonLocation: FloatingButtons.location,
        body: SafeArea(
          child: Scrollbar(
            controller: scrollController,
            child: CustomScrollView(
              cacheExtent: 1000,
              controller: scrollController,
              slivers: [
                ArticleListAppBar(type: type),
                const ArticleListSliver(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
