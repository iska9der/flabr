import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../scroll/cubit/scroll_cubit.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/article_list_cubit.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../repository/article_repository.dart';
import 'article_list_page.dart';

@RoutePage(name: NewsListPage.routeName)
class NewsListPage extends StatelessWidget {
  const NewsListPage({
    Key? key,
    @PathParam() required this.flow,
  }) : super(key: key);

  final String flow;

  static const String name = 'Новости';
  static const String routePath = 'flows/:flow';
  static const String routeName = 'NewsListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('news-$flow-flow'),
      providers: [
        BlocProvider(
          create: (c) => ArticleListCubit(
            getIt.get<ArticleRepository>(),
            type: ArticleType.news,
            flow: FlowEnum.fromString(flow),
            langUI: context.read<SettingsCubit>().state.langUI,
            langArticles: context.read<SettingsCubit>().state.langArticles,
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit()..setUpEdgeListeners(),
        ),
      ],
      child: const ArticleListPageView(type: ArticleType.news),
    );
  }
}
