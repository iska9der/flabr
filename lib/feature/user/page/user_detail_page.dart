import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widget/detail/section_container_widget.dart';
import '../../../common/widget/enhancement/progress_indicator.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../cubit/user_cubit.dart';
import '../widget/user_profile_card_widget.dart';
import '../widget/user_whois_widget.dart';

@RoutePage(name: UserDetailPage.routeName)
class UserDetailPage extends StatelessWidget {
  const UserDetailPage({super.key});

  static const String title = 'Профиль';
  static const String routePath = 'detail';
  static const String routeName = 'UserDetailRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UserCubit>();
    cubit.fetchCard();

    return UserDetailPageView(
      key: ValueKey('user-${cubit.state.login}-detail'),
    );
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
            return const Center(
              child: Text('Не удалось найти пользователя'),
            );
          }

          var model = state.model;

          return ListView(
            children: [
              const UserProfileCardWidget(),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: kScreenHPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Divider(),
                    if (model.fullname.isNotEmpty)
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.topLeft,
                        child: Text(
                          model.fullname,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    Text(
                      model.speciality.isNotEmpty
                          ? model.speciality
                          : 'Пользователь',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const Divider(),
                    SectionContainerWidget(
                      title: 'В рейтинге',
                      child: Text(
                        model.ratingPosition == 0
                            ? 'Не участвует'
                            : '${model.ratingPosition.toString()}-й',
                      ),
                    ),
                    if (model.location.fullLocation.isNotEmpty)
                      SectionContainerWidget(
                        title: 'Откуда',
                        child: Text(model.location.fullLocation),
                      ),
                    if (model.workplace.isNotEmpty) ...[
                      SectionContainerWidget(
                        title: 'Работает в',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: model.workplace.map((e) {
                            return TextButton(
                              onPressed: () => getIt.get<Utils>().showSnack(
                                    context: context,
                                    content: const Text('Здесь так тихо...'),
                                  ),
                              child: Text(e.title),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    SectionContainerWidget(
                      title: 'Зарегистрирован',
                      child: Text(
                          DateFormat.yMMMMEEEEd().format(model.registeredAt)),
                    ),
                    SectionContainerWidget(
                      title: 'Активность',
                      child: Text(
                          DateFormat.yMMMMEEEEd().format(model.lastActivityAt)),
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
