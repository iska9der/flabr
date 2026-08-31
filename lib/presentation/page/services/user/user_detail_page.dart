import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../bloc/user/user_cubit.dart';
import '../../../../i18n/i18n.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/detail/section_container_widget.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../../widget/error_widget.dart';
import 'widget/user_profile_card_widget.dart';
import 'widget/user_whois_widget.dart';

void _fetch(BuildContext context) => context.read<UserCubit>().fetchCard();

@RoutePage(name: UserDetailPage.routeName)
class UserDetailPage extends StatelessWidget {
  const UserDetailPage({
    super.key,
    @PathParam.inherit('alias') required this.alias,
  });

  final String alias;

  static const String routePath = 'detail';
  static const String routeName = 'UserDetailRoute';

  @override
  Widget build(BuildContext context) {
    _fetch(context);

    return UserDetailPageView(key: ValueKey('user-$alias-detail'));
  }
}

class UserDetailPageView extends StatelessWidget {
  const UserDetailPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state.status == .loading) {
          return const CircleIndicator();
        }

        if (state.status == .failure) {
          return Center(
            child: AppError(
              error: state.error,
              onRetry: () => _fetch(context),
            ),
          );
        }

        var user = state.model;

        return ListView(
          padding: AppInsets.screenPaddingExtended,
          children: [
            UserProfileCardWidget(user: user),
            Padding(
              padding: .symmetric(horizontal: AppInsets.cardPadding.left),
              child: Column(
                crossAxisAlignment: .stretch,
                children: [
                  SectionContainerWidget(
                    title: context.t.user.ranking.label,
                    child: Text(switch (user.ratingPosition == 0) {
                      true => context.t.user.notRanked,
                      false => context.t.user.ranking.position(
                        ratingPosition: user.ratingPosition,
                      ),
                    }),
                  ),
                  if (user.location.fullLocation.isNotEmpty)
                    SectionContainerWidget(
                      title: context.t.user.location,
                      child: Text(user.location.fullLocation),
                    ),
                  if (user.workplace.isNotEmpty) ...[
                    SectionContainerWidget(
                      title: context.t.user.worksAt,
                      child: Column(
                        crossAxisAlignment: .start,
                        children: user.workplace.map((e) {
                          return TextButton(
                            onPressed: () => context.showSnack(
                              content: Text(
                                context.t.user.detailsEmpty,
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
                      title: context.t.user.registered,
                      child: Text(
                        DateFormat.yMMMMEEEEd().format(user.registeredAt!),
                      ),
                    ),
                  if (user.lastActivityAt != null)
                    SectionContainerWidget(
                      title: context.t.user.activity,
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
    );
  }
}
