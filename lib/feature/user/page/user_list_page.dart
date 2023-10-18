import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils/utils.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/progress_indicator.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/user_list_cubit.dart';
import '../repository/user_repository.dart';
import '../widget/user_card_widget.dart';

@RoutePage(name: UserListPage.routeName)
class UserListPage extends StatelessWidget {
  const UserListPage({super.key});

  static const String name = 'Авторы';
  static const String routePath = 'users';
  static const String routeName = 'UserListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (c) => UserListCubit(
            getIt.get<UserRepository>(),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit()..setUpEdgeListeners(),
        ),
      ],
      child: Builder(
        builder: (context) {
          var usersCubit = context.read<UserListCubit>();

          return MultiBlocListener(
            listeners: [
              BlocListener<ScrollCubit, ScrollState>(
                listenWhen: (p, c) => c.isBottomEdge,
                listener: (c, s) => usersCubit.fetchAll(),
              ),
              BlocListener<SettingsCubit, SettingsState>(
                listenWhen: (p, c) =>
                    p.langArticles != c.langArticles || p.langUI != c.langUI,
                listener: (context, state) {
                  usersCubit.changeLanguages(
                    langUI: state.langUI,
                    langArticles: state.langArticles,
                  );
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
    var usersCubit = context.read<UserListCubit>();
    var scrollCubit = context.read<ScrollCubit>();
    var scrollCtrl = scrollCubit.state.controller;

    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text(UserListPage.name),
      ),
      floatingActionButton: const FloatingScrollToTopButton(),
      body: SafeArea(
        child: BlocConsumer<UserListCubit, UserListState>(
          listenWhen: (p, c) =>
              p.page != 1 && c.status == UserListStatus.failure,
          listener: (context, state) {
            getIt.get<Utils>().showNotification(
                  context: context,
                  content: Text(state.error),
                );
          },
          builder: (context, state) {
            if (state.status == UserListStatus.initial) {
              usersCubit.fetchAll();

              return const CircleIndicator();
            }

            if (usersCubit.isFirstFetch) {
              if (state.status == UserListStatus.loading) {
                return const CircleIndicator();
              }
              if (state.status == UserListStatus.failure) {
                return Center(child: Text(state.error));
              }
            }

            var users = state.users;

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
                itemCount: users.length +
                    (state.status == UserListStatus.loading ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i < users.length) {
                    return UserCardWidget(model: state.users[i]);
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
