import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../cubit/article_cubit.dart';
import '../repository/article_repository.dart';
import 'article_detail_page.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({
    Key? key,
    @PathParam() required this.id,
  }) : super(key: key);

  final String id;

  static const String routePath = 'details/:id';
  static const String routeName = 'NewsDetailRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('news-$id-detail'),
      create: (c) => ArticleCubit(
        id,
        repository: getIt.get<ArticleRepository>(),
        langUI: context.read<SettingsCubit>().state.langUI,
        langArticles: context.read<SettingsCubit>().state.langArticles,
      )..fetch(),
      child: const ArticleDetailPageView(),
    );
  }
}
