import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/detail/section_container_widget.dart';
import '../../../../widget/enhancement/progress_indicator.dart';
import '../cubit/user_cubit.dart';
import '../widget/user_profile_card_widget.dart';
import '../widget/user_whois_widget.dart';

@RoutePage(name: UserDetailPage.routeName)
class UserDetailPage extends StatelessWidget {
  const UserDetailPage({
    super.key,
    @PathParam.inherit('alias') required this.alias,
  });

  final String alias;

  static const String title = 'Профиль';
  static const String routePath = 'detail';
  static const String routeName = 'UserDetailRoute';

  @override
  Widget build(BuildContext context) {
    context.read<UserCubit>().fetchCard();

    return UserDetailPageView(key: ValueKey('user-$alias-detail'));
  }
}

class UserDetailPageView extends StatelessWidget {
  const UserDetailPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state.status.isLoading) {
            return const CircleIndicator();
          }

          if (state.status.isFailure) {
            return Center(child: Text(state.error));
          }

          var user = state.model;

          return ListView(
            children: [
              UserProfileCardWidget(user: user),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppInsets.screenPadding.left,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(),
                    if (user.fullname.isNotEmpty)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: Text(
                          user.fullname,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    Text(
                      user.speciality.isNotEmpty
                          ? user.speciality
                          : 'Пользователь',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Divider(),
                    SectionContainerWidget(
                      title: 'В рейтинге',
                      child: Text(
                        user.ratingPosition == 0
                            ? 'Не участвует'
                            : '${user.ratingPosition.toString()}-й',
                      ),
                    ),
                    if (user.location.fullLocation.isNotEmpty)
                      SectionContainerWidget(
                        title: 'Откуда',
                        child: Text(user.location.fullLocation),
                      ),
                    if (user.workplace.isNotEmpty) ...[
                      SectionContainerWidget(
                        title: 'Работает в',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              user.workplace.map((e) {
                                return TextButton(
                                  onPressed:
                                      () => context.showSnack(
                                        content: const Text(
                                          'Здесь так тихо...',
                                        ),
                                      ),
                                  child: Text(e.title),
                                );
                              }).toList(),
                        ),
                      ),
                    ],
                    if (user.registeredAt != null)
                      SectionContainerWidget(
                        title: 'Зарегистрирован',
                        child: Text(
                          DateFormat.yMMMMEEEEd().format(user.registeredAt!),
                        ),
                      ),
                    if (user.lastActivityAt != null)
                      SectionContainerWidget(
                        title: 'Активность',
                        child: Text(
                          DateFormat.yMMMMEEEEd().format(user.lastActivityAt!),
                        ),
                      ),
                    const UserWhoisWidget(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
