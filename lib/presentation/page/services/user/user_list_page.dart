import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/settings/settings_cubit.dart';
import '../../../../bloc/user/user_list_cubit.dart';
import '../../../../di/di.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../../i18n/i18n.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/error_widget.dart';
import '../../../widget/navigation/navigation.dart';
import '../../../widget/pagination.dart';
import 'widget/user_list_card_widget.dart';

@RoutePage(name: UserListPage.routeName)
class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  static const String routePath = 'users';
  static const String routeName = 'UserListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => UserListCubit(
            repository: getIt(),
            settingsRepository: getIt(),
          ),
        ),
        BlocProvider(create: (_) => ScrollCubit()),
      ],
      child: Builder(
        builder: (context) {
          final usersCubit = context.read<UserListCubit>();
          final scrollCubit = context.read<ScrollCubit>();
          final paginationEnabled = context.select<SettingsCubit, bool>(
            (cubit) => cubit.state.feed.navigationMode == .pagination,
          );
          return MultiBlocListener(
            listeners: [
              BlocListener<ScrollCubit, ScrollState>(
                listenWhen: (_, current) =>
                    !paginationEnabled && current.isBottomEdge,
                listener: (_, _) => usersCubit.fetchAll(),
              ),
              BlocListener<SettingsCubit, SettingsState>(
                listenWhen: (previous, current) =>
                    previous.feed.navigationMode != current.feed.navigationMode,
                listener: (_, _) {
                  usersCubit.reset();
                  scrollCubit.animateToTop();
                },
              ),
            ],
            child: const UserListPageView(),
          );
        },
      ),
    );
  }
}

class UserListPageView extends StatelessWidget {
  const UserListPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final usersCubit = context.read<UserListCubit>();
    final scrollCubit = context.read<ScrollCubit>();
    final scrollCtrl = scrollCubit.controller;
    final paginationEnabled = context.select<SettingsCubit, bool>(
      (cubit) => cubit.state.feed.navigationMode == .pagination,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: Text(context.t.user.list.title),
      ),
      floatingActionButton: const FloatingContainer(
        children: [FloatingScrollToTopButton()],
      ),
      body: SafeArea(
        child: BlocConsumer<UserListCubit, UserListState>(
          listenWhen: (previous, current) =>
              previous.users.isNotEmpty && current.status == .failure,
          listener: (context, state) => context.showSnack(
            content: Text(context.t.errorMessage(state.error)),
          ),
          builder: (context, state) {
            final users = state.users;

            if (state.status == .initial) {
              usersCubit.fetchAll();

              return const CircleIndicator();
            }

            if (users.isEmpty && state.status == .loading) {
              return const CircleIndicator();
            }

            if (users.isEmpty && state.status == .failure) {
              return Center(
                child: AppError(
                  error: state.error,
                  onRetry: () => usersCubit.fetchAll(),
                ),
              );
            }

            final paginationShown = paginationEnabled && state.pagesCount > 1;
            final loadingShown = !paginationEnabled && state.status == .loading;
            final itemCount =
                users.length + (paginationShown || loadingShown ? 1 : 0);

            return Scrollbar(
              controller: scrollCtrl,
              child: ListView.builder(
                controller: scrollCtrl,
                padding: AppInsets.screenExtended,
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  if (index < users.length) {
                    return UserListCardWidget(model: users[index]);
                  }

                  if (paginationShown) {
                    return Pagination(
                      currentPage: state.currentPage,
                      pagesCount: state.pagesCount,
                      onPageSelected: (page) {
                        usersCubit.changePage(page);
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
    );
  }
}
