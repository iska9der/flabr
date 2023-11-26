import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/cubit/auth_cubit.dart';
import '../../cubit/article_list_cubit.dart';
import '../../model/article_type.dart';
import '../../model/flow_enum.dart';

class FlowDropdownMenu extends StatelessWidget {
  const FlowDropdownMenu({super.key, required this.type});

  final ArticleType type;

  List<DropdownMenuItem<FlowEnum>> setUpEntries(bool isAuthorized) {
    List<DropdownMenuItem<FlowEnum>> entries = [];

    for (final flow in FlowEnum.values) {
      /// дергаем пункт "Моя лента"
      if (flow == FlowEnum.feed) {
        /// если мы не в статьях и не авторизованы, то не показываем
        /// этот пункт в drawer
        if (type != ArticleType.article || !isAuthorized) {
          continue;
        }
      }
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
    List<DropdownMenuItem<FlowEnum>> entries = [];

    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (_, current) => current.isUnauthorized || current.isAuthorized,
      builder: (context, authState) {
        entries = setUpEntries(authState.isAuthorized);

        return BlocBuilder<ArticleListCubit, ArticleListState>(
          buildWhen: (previous, current) => previous.flow != current.flow,
          builder: (context, articlesState) {
            return DropdownButton(
              value: articlesState.flow,
              underline: const SizedBox.shrink(),
              elevation: 0,
              padding: EdgeInsets.zero,
              onChanged: (value) {
                if (value == null) {
                  return;
                }

                context.read<ArticleListCubit>().changeFlow(value);
              },
              items: entries,
            );
          },
        );
      },
    );
  }
}
