import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/widget/progress_indicator.dart';
import '../../component/di/dependencies.dart';
import '../../feature/user/cubit/user_cubit.dart';
import '../../feature/user/service/users_service.dart';

class UserDetailPage extends StatelessWidget {
  const UserDetailPage({
    Key? key,
    @PathParam() required this.login,
  }) : super(key: key);

  final String login;

  static const String routePath = 'users/:login';
  static const String routeName = 'UserDetailRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('user-$login-detail'),
      create: (c) => UserCubit(
        login,
        service: getIt.get<UsersService>(),
      )..fetchByLogin(),
      child: const UserDetailPageView(),
    );
  }
}

class UserDetailPageView extends StatelessWidget {
  const UserDetailPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const AutoLeadingButton()),
      body: SafeArea(
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state.status == UserStatus.loading) {
              return const CircleIndicator();
            }

            if (state.status == UserStatus.failure) {
              return const Center(
                child: Text('Не удалось найти пользователя'),
              );
            }

            var model = state.model;

            return Column(
              children: [
                Text(model.fullName),
                Text(model.alias),
                Text(model.speciality),
              ],
            );
          },
        ),
      ),
    );
  }
}
