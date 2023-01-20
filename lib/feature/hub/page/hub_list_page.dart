import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils/utils.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/progress_indicator.dart';
import '../../scroll/cubit/scroll_cubit.dart';
import '../../scroll/widget/floating_scroll_to_top_button.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/hub_list_cubit.dart';
import '../model/hub_model.dart';
import '../repository/hub_repository.dart';
import '../widget/hub_card_widget.dart';

class HubListPage extends StatelessWidget {
  const HubListPage({Key? key}) : super(key: key);

  static const name = 'Хабы';
  static const routePath = 'hubs';
  static const routeName = 'HubListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: const ValueKey('hub-list'),
      providers: [
        BlocProvider(
          create: (c) => HubListCubit(
            getIt.get<HubRepository>(),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit()..setUpEdgeListeners(),
        ),
      ],
      child: const HubListPageView(),
    );
  }
}

class HubListPageView extends StatelessWidget {
  const HubListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HubListCubit>();
    final scrollCubit = context.read<ScrollCubit>();
    final scrollCtrl = scrollCubit.state.controller;

    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (previous, current) => current.isBottomEdge,
          listener: (context, state) => cubit.fetch(),
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.langUI != current.langUI ||
              previous.langArticles != current.langArticles,
          listener: (context, state) {
            context.read<HubListCubit>().changeLanguage(
                  langUI: state.langUI,
                  langArticles: state.langArticles,
                );
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text('Хабы'),
        ),
        floatingActionButton: const FloatingScrollToTopButton(),
        body: SafeArea(
          child: BlocConsumer<HubListCubit, HubListState>(
            listenWhen: (p, c) =>
                p.page != 1 && c.status == HubListStatus.failure,
            listener: (c, state) {
              getIt.get<Utils>().showNotification(
                    context: context,
                    content: Text(state.error),
                  );
            },
            builder: (context, state) {
              if (state.status == HubListStatus.initial) {
                cubit.fetch();

                return const CircleIndicator();
              }

              if (state.isFirstFetch) {
                if (state.status == HubListStatus.loading) {
                  return const CircleIndicator();
                }

                if (state.status == HubListStatus.failure) {
                  return Center(child: Text(state.error));
                }
              }

              return Scrollbar(
                controller: scrollCtrl,
                child: ListView.separated(
                  controller: scrollCtrl,
                  padding: const EdgeInsets.symmetric(
                    horizontal: kScreenHPadding,
                  ),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: kCardBetweenPadding,
                  ),
                  itemCount: state.list.refs.length +
                      (state.status == HubListStatus.loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.list.refs.length) {
                      HubModel item = state.list.refs[index];

                      return HubCardWidget(model: item);
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
