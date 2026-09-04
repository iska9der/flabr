import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/company/company_list_cubit.dart';
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
import 'widget/company_list_card_widget.dart';

@RoutePage(name: CompanyListPage.routeName)
class CompanyListPage extends StatelessWidget {
  const CompanyListPage({super.key});

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
            settingsRepository: getIt(),
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
    final paginationEnabled = context.select<SettingsCubit, bool>(
      (cubit) => cubit.state.feed.navigationMode == .pagination,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (previous, current) =>
              !paginationEnabled && current.isBottomEdge,
          listener: (context, state) => fetch(context),
        ),
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.feed.navigationMode != current.feed.navigationMode,
          listener: (_, _) {
            context.read<CompanyListCubit>().reset();
            scrollCubit.animateToTop();
          },
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
          title: Text(context.t.company.list.title),
        ),
        floatingActionButton: const FloatingContainer(
          children: [FloatingScrollToTopButton()],
        ),
        body: SafeArea(
          child: BlocConsumer<CompanyListCubit, CompanyListState>(
            listenWhen: (previous, current) =>
                previous.response.refs.isNotEmpty && current.status == .failure,
            listener: (c, state) {
              context.showSnack(
                content: Text(context.t.errorMessage(state.error)),
              );
            },
            builder: (context, state) {
              final companies = state.response.refs;

              if (state.status == .initial) {
                fetch(context);

                return const CircleIndicator();
              }

              if (companies.isEmpty && state.status == .loading) {
                return const CircleIndicator();
              }

              if (companies.isEmpty && state.status == .failure) {
                return Center(
                  child: AppError(
                    error: state.error,
                    onRetry: () => fetch(context),
                  ),
                );
              }

              final paginationShown =
                  paginationEnabled && state.response.pagesCount > 1;
              final loadingShown =
                  !paginationEnabled && state.status == .loading;
              final itemCount =
                  companies.length + (paginationShown || loadingShown ? 1 : 0);

              return Scrollbar(
                controller: scrollCtrl,
                child: ListView.builder(
                  controller: scrollCtrl,
                  padding: AppInsets.screenExtended,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    if (index < companies.length) {
                      final company = companies[index];

                      return CompanyListCardWidget(company: company);
                    }

                    if (paginationShown) {
                      return Pagination(
                        currentPage: state.currentPage,
                        pagesCount: state.response.pagesCount,
                        onPageSelected: (page) {
                          context.read<CompanyListCubit>().changePage(page);
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
