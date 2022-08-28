import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../feature/article/model/article_type.dart';
import '../../feature/scroll/cubit/scroll_controller_cubit.dart';
import '../../feature/article/cubit/articles_cubit.dart';
import '../../component/di/dependencies.dart';
import '../../feature/article/service/articles_service.dart';
import '../../feature/settings/cubit/settings_cubit.dart';
import '../articles/article_list_page.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({Key? key}) : super(key: key);

  static const String routePath = '';
  static const String routeName = 'NewsListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (c) => ArticlesCubit(
            getIt.get<ArticlesService>(),
            type: ArticleType.news,
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
