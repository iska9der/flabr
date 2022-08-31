import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../widget/progress_indicator.dart';
import '../../article/cubit/article_list_cubit.dart';
import '../../article/model/article_from_enum.dart';
import '../../article/model/flow_enum.dart';
import '../../article/page/article_list_page.dart';
import '../../article/service/article_service.dart';
import '../../scroll/cubit/scroll_cubit.dart';
import '../../scroll/widget/floating_scroll_to_top_button.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/hub_cubit.dart';
import '../widget/hub_profile_card_widget.dart';

class HubDetailPage extends StatelessWidget {
  const HubDetailPage({Key? key}) : super(key: key);

  static const name = 'Профиль';
  static const routePath = 'profile';
  static const routeName = 'HubDetailRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HubCubit>();

    cubit.fetchProfile();

    return BlocProvider(
      create: (c) => ScrollCubit()..setUpEdgeListeners(),
      child: HubDetailPageView(
        key: ValueKey('hub-${cubit.state.alias}-detail'),
      ),
    );
  }
}

class HubDetailPageView extends StatelessWidget {
  const HubDetailPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scrollCtrl = context.read<ScrollCubit>().state.controller;

    return Scaffold(
      floatingActionButton: const FloatingScrollToTopButton(),
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
  const _HubArticleListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HubCubit>();

    return MultiBlocProvider(
      key: ValueKey('articles-${cubit.state.alias}-hub'),
      providers: [
        BlocProvider(
          create: (c) => ArticleListCubit(
            getIt.get<ArticleService>(),
            from: ArticleFromEnum.hub,
            hub: cubit.state.alias,
            flow: FlowEnum.fromString('all'),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
      ],
      child: Builder(builder: (context) {
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

                articlesCubit.fetch();

                context.read<ScrollCubit>().animateToTop();
              },
            ),
          ],
          child: const ArticleList(),
        );
      }),
    );
  }
}
