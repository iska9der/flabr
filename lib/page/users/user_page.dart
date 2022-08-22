import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/widget/progress_indicator.dart';
import '../../component/di/dependencies.dart';
import '../../feature/user/cubit/user_cubit.dart';
import '../../feature/user/service/users_service.dart';

class UserPage extends StatelessWidget {
  const UserPage({
    Key? key,
    @PathParam() required this.login,
  }) : super(key: key);

  final String login;

  static const String routePath = ':login';
  static const String routeName = 'UserRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(
        login,
        service: getIt.get<UsersService>(),
      )..fetchByLogin(),
      child: const UserPageView(),
    );
  }
}

class UserPageView extends StatelessWidget {
  const UserPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
