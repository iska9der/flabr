import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/model/extension/num_x.dart';
import '../../common/model/stat_type.dart';
import '../../component/di/dependencies.dart';
import '../../config/constants.dart';
import '../../feature/article/cubit/article_list_cubit.dart';
import '../../feature/article/model/flow_enum.dart';
import '../../feature/article/service/article_service.dart';
import '../../feature/hub/cubit/hub_cubit.dart';
import '../../feature/scroll/cubit/scroll_cubit.dart';
import '../../feature/settings/cubit/settings_cubit.dart';
import '../../feature/user/widget/user_avatar_widget.dart';
import '../../widget/card_widget.dart';
import '../../widget/profile_stat_widget.dart';
import '../../widget/progress_indicator.dart';
import '../article/article_list_page.dart';

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
                SliverToBoxAdapter(child: _ProfileCardWidget()),
                _HubArticleListView(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileCardWidget extends StatelessWidget {
  const _ProfileCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HubCubit, HubState>(
      builder: (context, state) {
        var profile = state.profile;
        var stats = profile.statistics;

        return FlabrCard(
          padding: const EdgeInsets.symmetric(
            horizontal: kScreenHPadding,
            vertical: kScreenHPadding * 2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  UserAvatarWidget(
                    imageUrl: profile.imageUrl,
                    height: 60,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ProfileStatWidget(
                          type: StatType.rating,
                          title: 'Рейтинг',
                          text: stats.rating.toString(),
                        ),
                        ProfileStatWidget(
                          title: 'Подписчиков',
                          text: stats.subscribersCount.compact(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Text(
                profile.descriptionHtml,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              Text(
                profile.fullDescriptionHtml,
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        );
      },
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
            flow: FlowEnum.fromString('all'),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          )..fetchByHub(cubit.state.alias),
        ),
      ],
      child: Builder(builder: (context) {
        var cubit = context.read<HubCubit>();
        var articlesCubit = context.read<ArticleListCubit>();

        return MultiBlocListener(
          listeners: [
            BlocListener<ScrollCubit, ScrollState>(
              listenWhen: (p, c) => c.isBottomEdge,
              listener: (c, state) => context
                  .read<ArticleListCubit>()
                  .fetchByHub(cubit.state.alias),
            ),
            BlocListener<SettingsCubit, SettingsState>(
              listenWhen: (p, c) =>
                  p.langUI != c.langUI || p.langArticles != c.langArticles,
              listener: (context, state) {
                articlesCubit.changeLanguage(
                  langUI: state.langUI,
                  langArticles: state.langArticles,
                );

                context.read<ArticleListCubit>().fetchByHub(cubit.state.alias);

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
