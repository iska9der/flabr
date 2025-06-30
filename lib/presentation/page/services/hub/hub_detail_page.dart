import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/hub/hub_cubit.dart';
import '../../../../bloc/hub/hub_publication_list_cubit.dart';
import '../../../../bloc/settings/settings_cubit.dart';
import '../../../../data/model/filter/filter.dart';
import '../../../../di/di.dart';
import '../../../../feature/publication_list/publication_list.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/enhancement/refresh_indicator.dart';
import '../../../widget/filter/common_filters_widget.dart';
import 'widget/hub_profile_card_widget.dart';

@RoutePage(name: HubDetailPage.routeName)
class HubDetailPage extends StatelessWidget {
  const HubDetailPage({
    super.key,
    @PathParam.inherit('alias') required this.alias,
  });

  final String alias;

  static const name = 'Профиль';
  static const routePath = 'profile';
  static const routeName = 'HubDetailRoute';

  @override
  Widget build(BuildContext context) {
    context.read<HubCubit>().fetchProfile();

    return MultiBlocProvider(
      key: ValueKey('hub-$alias-detail'),
      providers: [
        BlocProvider(
          create:
              (_) => HubPublicationListCubit(
                repository: getIt(),
                languageRepository: getIt(),
                hub: alias,
              ),
        ),
        BlocProvider(create: (_) => ScrollCubit()),
      ],
      child: const HubDetailPageView(),
    );
  }
}

class HubDetailPageView extends StatelessWidget {
  const HubDetailPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit>();
    final scrollCtrl = scrollCubit.state.controller;
    final scrollPhysics = context.select<SettingsCubit, ScrollPhysics>(
      (cubit) => cubit.state.misc.scrollVariant.physics(context),
    );

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const FloatingScrollToTopButton(),
          FloatingFilterButton<
            HubPublicationListCubit,
            HubPublicationListState
          >(
            filter:
                BlocBuilder<HubPublicationListCubit, HubPublicationListState>(
                  builder: (context, state) {
                    return CommonFiltersWidget(
                      isLoading: state.status == PublicationListStatus.loading,
                      sort: state.filter.sort,
                      filterOption: switch (state.filter.sort) {
                        Sort.byBest => state.filter.period,
                        Sort.byNew => state.filter.score,
                      },
                      onSubmit:
                          context.read<HubPublicationListCubit>().applyFilter,
                    );
                  },
                ),
          ),
        ],
      ),
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
              physics: scrollPhysics,
              slivers: [
                FlabrSliverRefreshIndicator(
                  onRefresh: context.read<HubPublicationListCubit>().refetch,
                ),
                SliverToBoxAdapter(
                  child: HubProfileCardWidget(profile: state.profile),
                ),
                const _HubArticleListView(),
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
    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (previous, current) => current.isBottomEdge,
          listener: (_, _) => context.read<HubPublicationListCubit>().fetch(),
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen:
              (previous, current) =>
                  previous.langUI != current.langUI ||
                  previous.langArticles != current.langArticles,
          listener: (_, __) => context.read<ScrollCubit>().animateToTop(),
        ),
      ],
      child:
          const PublicationSliverList<
            HubPublicationListCubit,
            HubPublicationListState
          >(),
    );
  }
}
