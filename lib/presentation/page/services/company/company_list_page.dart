import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/company/company_list_cubit.dart';
import '../../../../bloc/settings/settings_cubit.dart';
import '../../../../di/di.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../extension/extension.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/error_widget.dart';
import '../../../widget/navigation/navigation.dart';
import 'widget/company_card_widget.dart';

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
        BlocProvider(create: (_) => ScrollCubit()),
      ],
      child: const CompanyListPageView(),
    );
  }
}

class CompanyListPageView extends StatelessWidget {
  const CompanyListPageView({super.key});

  void fetch(BuildContext context) => context.read<CompanyListCubit>().fetch();

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit>();
    final scrollCtrl = scrollCubit.controller;

    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (previous, current) => current.isBottomEdge,
          listener: (context, state) => fetch(context),
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.langUI != current.langUI ||
              previous.langArticles != current.langArticles,
          listener: (_, _) => scrollCubit.animateToTop(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const AutoLeadingButton(),
          title: const Text(CompanyListPage.name),
        ),
        floatingActionButton: const FloatingContainer(
          children: [FloatingScrollToTopButton()],
        ),
        body: SafeArea(
          child: BlocConsumer<CompanyListCubit, CompanyListState>(
            listenWhen: (p, c) => p.page != 1 && c.status == .failure,
            listener: (c, state) {
              context.showSnack(content: Text(state.error));
            },
            builder: (context, state) {
              if (state.status == .initial) {
                fetch(context);

                return const CircleIndicator();
              }

              if (state.isFirstFetch) {
                if (state.status == .loading) {
                  return const CircleIndicator();
                }

                if (state.status == .failure) {
                  return Center(
                    child: AppError(
                      message: state.error,
                      onRetry: () => fetch(context),
                    ),
                  );
                }
              }

              return Scrollbar(
                controller: scrollCtrl,
                child: ListView.builder(
                  controller: scrollCtrl,
                  itemCount:
                      state.response.refs.length +
                      (state.status == .loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index < state.response.refs.length) {
                      final company = state.response.refs[index];

                      return CompanyCardWidget(company: company);
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
