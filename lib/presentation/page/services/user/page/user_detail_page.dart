import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../extension/part.dart';
import '../../../../theme/theme.dart';
import '../../../../utils/utils.dart';
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

    return UserDetailPageView(
      key: ValueKey('user-$alias-detail'),
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
                              onPressed: () => getIt<Utils>().showSnack(
                                context: context,
                                content: const Text('Здесь так тихо...'),
                              ),
                              child: Text(e.title),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                    if (model.registeredAt != null)
                      SectionContainerWidget(
                        title: 'Зарегистрирован',
                        child: Text(
                          DateFormat.yMMMMEEEEd().format(model.registeredAt!),
                        ),
                      ),
                    if (model.lastActivityAt != null)
                      SectionContainerWidget(
                        title: 'Активность',
                        child: Text(
                          DateFormat.yMMMMEEEEd().format(model.lastActivityAt!),
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
