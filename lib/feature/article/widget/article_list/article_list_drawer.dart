import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/cubit/auth_cubit.dart';
import '../../cubit/article_list_cubit.dart';
import '../../model/article_type.dart';
import '../../model/flow_enum.dart';

class ArticleListDrawer extends StatelessWidget {
  const ArticleListDrawer({super.key, required this.type});

  final ArticleType type;

  _onItemTap(BuildContext context, FlowEnum flow) {
    final articlesCubit = context.read<ArticleListCubit>();

    articlesCubit.changeFlow(flow);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final currentFlow = context.read<ArticleListCubit>().state.flow;
    final isAuthorized = context.read<AuthCubit>().state.isAuthorized;

    return DrawerTheme(
      data: Theme.of(context).drawerTheme.copyWith(
            width: MediaQuery.of(context).size.width * .6,
          ),
      child: NavigationDrawer(
        children: FlowEnum.values.map((flow) {
          /// дергаем пункт "Моя лента"
          if (flow == FlowEnum.feed) {
            /// если мы не в статьях и не авторизованы, то не показываем
            /// этот пункт в drawer
            if (type != ArticleType.article || !isAuthorized) {
              return const SizedBox();
            }
          }

          return ListTile(
            title: Text(flow.label),
            selected: currentFlow == flow,
            onTap: () => _onItemTap(context, flow),
          );
        }).toList(),
      ),
    );
  }
}
