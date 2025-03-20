import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../../data/model/company/company_model.dart';
import '../../../../../feature/scroll/scroll.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/utils.dart';
import '../../../../widget/enhancement/progress_indicator.dart';
import '../../../settings/cubit/settings_cubit.dart';
import '../cubit/company_list_cubit.dart';
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
          create: (_) => CompanyListCubit(
            repository: getIt(),
            languageRepository: getIt(),
          ),
        ),
        BlocProvider(
          create: (_) => ScrollCubit(),
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
          listener: (_, __) => scrollCubit.animateToTop(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text(CompanyListPage.name),
        ),
        floatingActionButton: const FloatingScrollToTopButton(),
        body: SafeArea(
          child: BlocConsumer<CompanyListCubit, CompanyListState>(
            listenWhen: (p, c) =>
                p.page != 1 && c.status == CompanyListStatus.failure,
            listener: (c, state) {
              getIt<Utils>().showSnack(
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
                  separatorBuilder: (context, index) => const SizedBox(
                    height: AppDimensions.cardBetweenHeight,
                  ),
                  itemCount: state.list.refs.length +
                      (state.status == CompanyListStatus.loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.list.refs.length) {
                      Company item = state.list.refs[index];

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
