import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../feature/scroll/part.dart';
import '../../../../theme/part.dart';
import '../../../../utils/utils.dart';
import '../../../../widget/enhancement/progress_indicator.dart';
import '../cubit/user_list_cubit.dart';
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
          create: (_) => UserListCubit(
            repository: getIt(),
            languageRepository: getIt(),
          ),
        ),
        BlocProvider(
          create: (_) => ScrollCubit(),
        ),
      ],
      child: Builder(
        builder: (context) {
          var usersCubit = context.read<UserListCubit>();

          return MultiBlocListener(
            listeners: [
              BlocListener<ScrollCubit, ScrollState>(
                listenWhen: (_, current) => current.isBottomEdge,
                listener: (_, __) => usersCubit.fetchAll(),
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
          listener: (context, state) => getIt<Utils>().showSnack(
            context: context,
            content: Text(state.error),
          ),
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
