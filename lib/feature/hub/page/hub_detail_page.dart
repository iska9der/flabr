import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/enhancement/progress_indicator.dart';
import '../../../common/widget/publication_sliver_list.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../publication/repository/publication_repository.dart';
import '../../publication/widget/sort/articles_sort_widget.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../../settings/repository/language_repository.dart';
import '../cubit/hub_cubit.dart';
import '../cubit/hub_publication_list_cubit.dart';
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
          create: (_) => HubPublicationListCubit(
            repository: getIt.get<PublicationRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
            hub: cubit.state.alias,
          ),
        ),
        BlocProvider(
          create: (_) => ScrollCubit(),
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
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  floating: true,
                  toolbarHeight: fSortToolbarHeight,
                  title: ArticlesSortWidget<HubPublicationListCubit,
                      HubPublicationListState>(),
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
    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (previous, current) => current.isBottomEdge,
          listener: (_, __) => context.read<HubPublicationListCubit>().fetch(),
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.langUI != current.langUI ||
              previous.langArticles != current.langArticles,
          listener: (_, __) => context.read<ScrollCubit>().animateToTop(),
        ),
      ],
      child: const PublicationSliverList<HubPublicationListCubit,
          HubPublicationListState>(),
    );
  }
}
