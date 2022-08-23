import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/cubit/scroll_controller_cubit.dart';
import '../../common/utils/utils.dart';
import '../../common/widget/progress_indicator.dart';
import '../../component/di/dependencies.dart';
import '../../feature/user/cubit/users_cubit.dart';
import '../../feature/user/model/user_model.dart';
import '../../feature/user/service/users_service.dart';
import 'user_detail_page.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({Key? key}) : super(key: key);

  static const String routePath = 'users';
  static const String routeName = 'UserListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (c) => UsersCubit(getIt.get<UsersService>())..fetchAll(),
        ),
        BlocProvider(
          create: (c) => ScrollControllerCubit()..setUpEdgeListeners(),
        ),
      ],
      child: const UserListPageView(),
    );
  }
}

class UserListPageView extends StatelessWidget {
  const UserListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.read<ScrollControllerCubit>().state.controller;

    return BlocListener<ScrollControllerCubit, ScrollControllerState>(
      listener: (c, state) {
        if (state.isBottomEdge) {
          context.read<UsersCubit>().fetchAll();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: BlocConsumer<UsersCubit, UsersState>(
            listenWhen: (p, c) =>
                p.page != 1 && c.status == UsersStatus.failure,
            listener: (context, state) {
              getIt.get<Utils>().showNotification(
                    context: context,
                    content: Text(state.error),
                  );
            },
            builder: (context, state) {
              if (context.read<UsersCubit>().isFirstFetch) {
                if (state.status == UsersStatus.loading) {
                  return const CircleIndicator();
                }
                if (state.status == UsersStatus.failure) {
                  return Center(child: Text(state.error));
                }
              }

              var users = state.users;

              return ListView.builder(
                controller: controller,
                itemCount: users.length +
                    (state.status == UsersStatus.loading ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i < users.length) {
                    return UserCard(state.users[i]);
                  } else {
                    Timer(
                      const Duration(milliseconds: 30),
                      () => context
                          .read<ScrollControllerCubit>()
                          .animateToBottom(),
                    );

                    return const SizedBox(
                      height: 60,
                      child: CircleIndicator.medium(),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard(this.model, {Key? key}) : super(key: key);

  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: ListTile(
        title: Text(model.alias),
        tileColor: Colors.amber,
        onTap: () =>
            context.router.pushWidget(UserDetailPage(login: model.alias)),
      ),
    );
  }
}
