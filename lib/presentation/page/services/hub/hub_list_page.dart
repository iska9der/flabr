import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/hub/hub_list_cubit.dart';
import '../../../../bloc/settings/settings_cubit.dart';
import '../../../../di/di.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../../i18n/i18n.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/error_widget.dart';
import '../../../widget/navigation/navigation.dart';
import '../../../widget/pagination.dart';
import 'widget/hub_list_card_widget.dart';

@RoutePage(name: HubListPage.routeName)
class HubListPage extends StatelessWidget {
  const HubListPage({super.key});

  static const routePath = 'hubs';
  static const routeName = 'HubListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: const ValueKey('hub-list'),
      providers: [
        BlocProvider(
          create: (_) => HubListCubit(
            repository: getIt(),
            settingsRepository: getIt(),
          ),
        ),
        BlocProvider(create: (c) => ScrollCubit()),
      ],
      child: const HubListPageView(),
    );
  }
}

class HubListPageView extends StatelessWidget {
  const HubListPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HubListCubit>();
    final scrollCubit = context.read<ScrollCubit>();
    final scrollCtrl = scrollCubit.controller;
    final paginationEnabled = context.select<SettingsCubit, bool>(
      (cubit) => cubit.state.feed.navigationMode == .pagination,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (_, current) =>
              !paginationEnabled && current.isBottomEdge,
          listener: (_, _) => cubit.fetch(),
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.feed.navigationMode != current.feed.navigationMode,
          listener: (_, _) {
            cubit.reset();
            scrollCubit.animateToTop();
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: Text(context.t.hub.list.title),
        ),
        floatingActionButton: const FloatingContainer(
          children: [FloatingScrollToTopButton()],
        ),
        body: SafeArea(
          child: BlocConsumer<HubListCubit, HubListState>(
            listenWhen: (previous, current) =>
                previous.list.refs.isNotEmpty && current.status == .failure,
            listener: (c, state) {
              context.showSnack(
                content: Text(context.t.errorMessage(state.error)),
              );
            },
            builder: (context, state) {
              final hubs = state.list.refs;

              if (state.status == .initial) {
                cubit.fetch();

                return const CircleIndicator();
              }

              if (hubs.isEmpty && state.status == .loading) {
                return const CircleIndicator();
              }

              if (hubs.isEmpty && state.status == .failure) {
                return Center(
                  child: AppError(
                    error: state.error,
                    onRetry: () => cubit.fetch(),
                  ),
                );
              }

              final paginationShown =
                  paginationEnabled && state.list.pagesCount > 1;
              final loadingShown =
                  !paginationEnabled && state.status == .loading;
              final itemCount =
                  hubs.length + (paginationShown || loadingShown ? 1 : 0);

              return Scrollbar(
                controller: scrollCtrl,
                child: ListView.builder(
                  controller: scrollCtrl,
                  padding: AppInsets.screenExtended,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index < hubs.length) {
                      final item = hubs[index];

                      return HubListCardWidget(model: item);
                    }

                    if (paginationShown) {
                      return Pagination(
                        currentPage: state.currentPage,
                        pagesCount: state.list.pagesCount,
                        onPageSelected: (page) {
                          cubit.changePage(page);
                          scrollCubit.animateToTop();
                        },
                      );
                    }

                    Timer(
                      scrollCubit.duration,
                      () => scrollCubit.animateToBottom(),
                    );

                    return const SizedBox(
                      height: 60,
                      child: CircleIndicator.medium(),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
