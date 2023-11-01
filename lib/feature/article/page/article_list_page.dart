import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widget/article_list_sliver.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../enhancement/scroll/cubit/scroll_cubit.dart';
import '../../enhancement/scroll/widget/floating_scroll_to_top_button.dart';
import '../../search/cubit/search_cubit.dart';
import '../../search/repository/search_repository.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../../settings/repository/language_repository.dart';
import '../cubit/article_list_cubit.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../repository/article_repository.dart';
import '../widget/article_list/article_list_appbar.dart';
import '../widget/most_reading_widget.dart';

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
          create: (_) => ArticleListCubit(
            repository: getIt.get<ArticleRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
            flow: FlowEnum.fromString(flow),
          ),
        ),
        BlocProvider(
          create: (_) => SearchCubit(
            repository: getIt.get<SearchRepository>(),
            langRepository: getIt.get<LanguageRepository>(),
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit(),
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
          listenWhen: (previous, current) =>
              previous.langUI != current.langUI ||
              previous.langArticles != current.langArticles,
          listener: (_, __) => scrollCubit.animateToTop(),
        ),

        /// Когда скролл достиг предела, получаем следующую страницу
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (p, c) => c.isBottomEdge,
          listener: (c, state) => articlesCubit.fetch(),
        ),
      ],
      child: Scaffold(
        floatingActionButton: const FloatingScrollToTopButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Scrollbar(
            controller: scrollController,
            child: CustomScrollView(
              cacheExtent: 1000,
              controller: scrollController,
              slivers: [
                ArticleListAppBar(type: type),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: kScreenHPadding + kCardMargin,
                      vertical: kCardBetweenPadding / 2,
                    ),
                    child: MostReadingWidget(),
                  ),
                ),
                const ArticleListSliver(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
