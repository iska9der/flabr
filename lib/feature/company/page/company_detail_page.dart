import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/widget/enhancement/progress_indicator.dart';
import '../../../config/constants.dart';
import '../cubit/company_cubit.dart';
import '../widget/company_details_widget.dart';
import '../widget/company_profile_card_widget.dart';

@RoutePage(name: CompanyDetailPage.routeName)
class CompanyDetailPage extends StatelessWidget {
  const CompanyDetailPage({super.key});

  static const String title = 'Профиль';
  static const String routePath = 'profile';
  static const String routeName = 'CompanyDetailRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CompanyCubit>();

    cubit.fetchCard();

    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        if (state.status.isLoading) {
          return const CircleIndicator();
        }

        if (state.status.isFailure) {
          return Center(child: Text(state.error));
        }

        return ListView(
          padding: const EdgeInsets.all(kScreenHPadding),
          children: const [
            CompanyProfileCardWidget(),
            CompanyDetailsWidget(),
          ],
        );
      },
    );
  }
}
