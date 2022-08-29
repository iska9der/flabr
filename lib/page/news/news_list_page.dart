import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/article/model/article_type.dart';
import '../../feature/article/model/flow_enum.dart';
import '../../feature/scroll/cubit/scroll_controller_cubit.dart';
import '../../feature/article/cubit/articles_cubit.dart';
import '../../component/di/dependencies.dart';
import '../../feature/article/service/article_service.dart';
import '../../feature/settings/cubit/settings_cubit.dart';
import '../article/article_list_page.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({
    Key? key,
    @PathParam() required this.flow,
  }) : super(key: key);

  final String flow;

  static const String routePath = 'flows/:flow';
  static const String routeName = 'NewsListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('news-$flow-flow'),
      providers: [
        BlocProvider(
          create: (c) => ArticlesCubit(
            getIt.get<ArticleService>(),
            type: ArticleType.news,
            flow: FlowEnum.fromString(flow),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollControllerCubit()..setUpEdgeListeners(),
        ),
      ],
      child: const ArticleListPageView(),
    );
  }
}
