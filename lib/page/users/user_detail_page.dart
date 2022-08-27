import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/utils/utils.dart';
import '../../config/constants.dart';
import '../../widget/card_widget.dart';
import '../../widget/progress_indicator.dart';
import '../../component/di/dependencies.dart';
import '../../feature/user/cubit/user_cubit.dart';
import '../../feature/user/service/users_service.dart';
import '../../feature/user/widget/user_avatar_widget.dart';

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
      appBar: AppBar(),
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

            return ListView(
              padding: const EdgeInsets.all(kScreenHPadding),
              children: [
                FlabrCard(
                  padding: const EdgeInsets.all(kCardPadding),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: UserAvatarWidget(
                          imageUrl: model.avatar,
                          height: 50,
                        ),
                      ),
                      const Expanded(child: _UserScores())
                    ],
                  ),
                ),
                Text(
                  model.alias,
                  style: Theme.of(context).textTheme.headline3,
                ),
                Text(
                  model.speciality.isNotEmpty
                      ? model.speciality
                      : 'Пользователь',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 60),
                _Section(
                  title: 'В рейтинге',
                  child: Text('${model.ratingPosition.toString()}-й'),
                ),
                if (model.location.fullLocation.isNotEmpty)
                  _Section(
                    title: 'Откуда',
                    child: Text(model.location.fullLocation),
                  ),
                if (model.workplace.isNotEmpty) ...[
                  _Section(
                    title: 'Работает в',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: model.workplace.map((e) {
                        return TextButton(
                          onPressed: () => getIt.get<Utils>().showNotification(
                                context: context,
                                content: const Text('Здесь так тихо...'),
                              ),
                          child: Text(e.title),
                        );
                      }).toList(),
                    ),
                  ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _UserScores extends StatelessWidget {
  const _UserScores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        var model = state.model;

        return Row(
          children: [
            Column(
              children: [
                Text(
                  model.score.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.green),
                ),
                Text(
                  'Очки',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
            const SizedBox(width: 40),
            Column(
              children: [
                Text(
                  model.rating.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      ?.copyWith(color: Colors.purple),
                ),
                Text(
                  'Рейтинг',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
