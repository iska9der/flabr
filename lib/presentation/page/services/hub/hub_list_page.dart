import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/hub/hub_list_cubit.dart';
import '../../../../data/model/hub/hub.dart';
import '../../../../di/di.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import 'widget/hub_card_widget.dart';

@RoutePage(name: HubListPage.routeName)
class HubListPage extends StatelessWidget {
  const HubListPage({super.key});

  static const name = 'Хабы';
  static const routePath = 'hubs';
  static const routeName = 'HubListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: const ValueKey('hub-list'),
      providers: [
        BlocProvider(create: (_) => HubListCubit(repository: getIt())),
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
    final scrollCtrl = scrollCubit.state.controller;

    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (_, current) => current.isBottomEdge,
          listener: (_, _) => cubit.fetch(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text(HubListPage.name),
        ),
        floatingActionButton: const FloatingScrollToTopButton(),
        body: SafeArea(
          child: BlocConsumer<HubListCubit, HubListState>(
            listenWhen:
                (p, c) => p.page != 1 && c.status == HubListStatus.failure,
            listener: (c, state) {
              context.showSnack(content: Text(state.error));
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
                  separatorBuilder:
                      (context, index) => const SizedBox(
                        height: AppDimensions.cardBetweenHeight,
                      ),
                  itemCount:
                      state.list.refs.length +
                      (state.status == HubListStatus.loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.list.refs.length) {
                      Hub item = state.list.refs[index];

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
