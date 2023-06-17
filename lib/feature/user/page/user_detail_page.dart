import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../common/model/stat_type.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widget/detail/section_container_widget.dart';
import '../../../common/widget/list_card/card_avatar_widget.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/card_widget.dart';
import '../../../widget/profile_stat_widget.dart';
import '../../../widget/progress_indicator.dart';
import '../cubit/user_cubit.dart';
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
    cubit.fetchByLogin();

    return UserDetailPageView(
      key: ValueKey('user-${cubit.state.login}-detail'),
    );
  }
}

class UserDetailPageView extends StatelessWidget {
  const UserDetailPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
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
          padding: const EdgeInsets.all(kScreenHPadding),
          children: [
            FlabrCard(
              padding: const EdgeInsets.all(kCardPadding),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: CardAvatarWidget(
                      imageUrl: model.avatarUrl,
                      height: 50,
                    ),
                  ),
                  const Expanded(child: _UserScoresWidget())
                ],
              ),
            ),
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
              model.speciality.isNotEmpty ? model.speciality : 'Пользователь',
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
                      onPressed: () => getIt.get<Utils>().showNotification(
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
              child: Text(DateFormat.yMMMMEEEEd().format(model.registeredAt)),
            ),
            SectionContainerWidget(
              title: 'Активность',
              child: Text(DateFormat.yMMMMEEEEd().format(model.lastActivityAt)),
            ),
            const UserWhoisWidget(),
          ],
        );
      },
    );
  }
}

class _UserScoresWidget extends StatelessWidget {
  const _UserScoresWidget();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        var model = state.model;

        return Row(
          children: [
            ProfileStatWidget(
              type: StatType.score,
              title: 'Очки',
              value: model.score,
            ),
            const SizedBox(width: 40),
            ProfileStatWidget(
              type: StatType.rating,
              title: 'Рейтинг',
              value: model.rating,
            ),
          ],
        );
      },
    );
  }
}
