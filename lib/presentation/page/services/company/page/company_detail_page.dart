import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../extension/extension.dart';
import '../../../../theme/theme.dart';
import '../../../../widget/enhancement/progress_indicator.dart';
import '../cubit/company_cubit.dart';
import '../widget/company_details_widget.dart';
import '../widget/company_profile_card_widget.dart';

@RoutePage(name: CompanyDetailPage.routeName)
class CompanyDetailPage extends StatelessWidget {
  const CompanyDetailPage({
    super.key,
    @PathParam.inherit('alias') required this.alias,
  });

  final String alias;

  static const String title = 'Профиль';
  static const String routePath = 'profile';
  static const String routeName = 'CompanyDetailRoute';

  @override
  Widget build(BuildContext context) {
    context.read<CompanyCubit>().fetchCard();

    return BlocBuilder<CompanyCubit, CompanyState>(
      builder: (context, state) {
        if (state.status.isLoading) {
          return const CircleIndicator();
        }

        if (state.status.isFailure) {
          return Center(child: Text(state.error));
        }

        return ListView(
          children: [
            CompanyProfileCardWidget(card: state.card),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPadding,
              ),
              child: CompanyDetailsWidget(card: state.card),
            ),
          ],
        );
      },
    );
  }
}
