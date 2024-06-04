import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../../data/model/publication/publication_flow_enum.dart';
import '../../../feature/auth/cubit/auth_cubit.dart';
import '../../../theme/part.dart';
import '../cubit/flow_publication_list_cubit.dart';

class FlowDropdownMenu extends StatelessWidget {
  const FlowDropdownMenu({super.key});

  List<DropdownMenuItem<PublicationFlow>> setUpEntries(bool isAuthorized) {
    List<DropdownMenuItem<PublicationFlow>> entries = [];

    for (final flow in PublicationFlow.values) {
      final entry = DropdownMenuItem(
        value: flow,
        child: Text(flow.label),
      );
      entries.add(entry);
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuItem<PublicationFlow>> entries = [];

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, current) => current.isUnauthorized || current.isAuthorized,
      builder: (context, authState) {
        entries = setUpEntries(authState.isAuthorized);

        return BlocBuilder<FlowPublicationListCubit, FlowPublicationListState>(
          buildWhen: (previous, current) => previous.flow != current.flow,
          builder: (context, articlesState) {
            return DropdownButton(
              value: articlesState.flow,
              underline: const SizedBox.shrink(),
              elevation: 0,
              padding: EdgeInsets.zero,
              isExpanded: ResponsiveValue<bool>(
                context,
                defaultValue: true,
                conditionalValues: [
                  const Condition.largerThan(
                    name: ScreenType.mobile,
                    value: false,
                  ),
                ],
              ).value,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                context.read<FlowPublicationListCubit>().changeFlow(value);
              },
              items: entries,
            );
          },
        );
      },
    );
  }
}
