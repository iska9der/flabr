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
import '../cubit/company_list_cubit.dart';
import '../model/company_model.dart';
import '../repository/company_repository.dart';
import '../widget/company_card_widget.dart';

@RoutePage(name: CompanyListPage.routeName)
class CompanyListPage extends StatelessWidget {
  const CompanyListPage({super.key});

  static const name = 'Компании';
  static const routePath = 'companies';
  static const routeName = 'CompanyListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: const ValueKey('company-list'),
      providers: [
        BlocProvider(
          create: (c) => CompanyListCubit(
            getIt.get<CompanyRepository>(),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit()..setUpEdgeListeners(),
        ),
      ],
      child: const CompanyListPageView(),
    );
  }
}

class CompanyListPageView extends StatelessWidget {
  const CompanyListPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompanyListCubit>();
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
            context.read<CompanyListCubit>().changeLanguage(
                  langUI: state.langUI,
                  langArticles: state.langArticles,
                );
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text('Компании'),
        ),
        floatingActionButton: const FloatingScrollToTopButton(),
        body: SafeArea(
          child: BlocConsumer<CompanyListCubit, CompanyListState>(
            listenWhen: (p, c) =>
                p.page != 1 && c.status == CompanyListStatus.failure,
            listener: (c, state) {
              getIt.get<Utils>().showNotification(
                    context: context,
                    content: Text(state.error),
                  );
            },
            builder: (context, state) {
              if (state.status == CompanyListStatus.initial) {
                cubit.fetch();

                return const CircleIndicator();
              }

              if (state.isFirstFetch) {
                if (state.status == CompanyListStatus.loading) {
                  return const CircleIndicator();
                }

                if (state.status == CompanyListStatus.failure) {
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
                      (state.status == CompanyListStatus.loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.list.refs.length) {
                      CompanyModel item = state.list.refs[index];

                      return CompanyCardWidget(model: item);
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
