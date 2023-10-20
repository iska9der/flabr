import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/button/common_floating_action_button.dart';
import '../../../widget/progress_indicator.dart';
import '../../article/cubit/article_list_cubit.dart';
import '../../article/model/article_from_enum.dart';
import '../../article/model/flow_enum.dart';
import '../../article/page/article_list_page.dart';
import '../../article/repository/article_repository.dart';
import '../../article/widget/sort/articles_sort_widget.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/hub_cubit.dart';
import '../widget/hub_profile_card_widget.dart';

@RoutePage(name: HubDetailPage.routeName)
class HubDetailPage extends StatelessWidget {
  const HubDetailPage({super.key});

  static const name = 'Профиль';
  static const routePath = 'profile';
  static const routeName = 'HubDetailRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HubCubit>();

    cubit.fetchProfile();

    return MultiBlocProvider(
      key: ValueKey('hub-${cubit.state.alias}-detail'),
      providers: [
        BlocProvider(
          create: (c) => ArticleListCubit(
            getIt.get<ArticleRepository>(),
            from: ArticleFromEnum.hub,
            hub: cubit.state.alias,
            flow: FlowEnum.fromString('all'),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit(),
        ),
      ],
      child: const HubDetailPageView(),
    );
  }
}

class HubDetailPageView extends StatelessWidget {
  const HubDetailPageView({super.key});

  @override
  Widget build(BuildContext context) {
    var scrollCtrl = context.read<ScrollCubit>().state.controller;

    return Scaffold(
      floatingActionButton: const CommonFloatingActionButton(),
      floatingActionButtonLocation: CommonFloatingActionButton.location,
      body: BlocBuilder<HubCubit, HubState>(
        builder: (context, state) {
          if (state.status == HubStatus.loading) {
            return const CircleIndicator();
          }

          if (state.status == HubStatus.failure) {
            return Center(child: Text(state.error));
          }

          return Scrollbar(
            controller: scrollCtrl,
            child: CustomScrollView(
              controller: scrollCtrl,
              slivers: const [
                SliverToBoxAdapter(child: HubProfileCardWidget()),
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  floating: true,
                  toolbarHeight: sortToolbarHeight,
                  title: ArticlesSortWidget(),
                ),
                _HubArticleListView(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _HubArticleListView extends StatelessWidget {
  const _HubArticleListView();

  @override
  Widget build(BuildContext context) {
    var articlesCubit = context.read<ArticleListCubit>();

    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (p, c) => c.isBottomEdge,
          listener: (c, state) => articlesCubit.fetch(),
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (p, c) =>
              p.langUI != c.langUI || p.langArticles != c.langArticles,
          listener: (context, state) {
            articlesCubit.changeLanguage(
              langUI: state.langUI,
              langArticles: state.langArticles,
            );

            context.read<ScrollCubit>().animateToTop();
          },
        ),
      ],
      child: const ArticleSliverList(),
    );
  }
}
