import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../enhancement/scaffold/scaffold.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../settings/repository/language_repository.dart';
import '../cubit/article_list_cubit.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../repository/article_repository.dart';
import 'article_list_page.dart';

@RoutePage(name: PostListPage.routeName)
class PostListPage extends StatelessWidget {
  const PostListPage({
    super.key,
    @PathParam() required this.flow,
  });

  final String flow;

  static const String name = 'Посты';
  static const String routePath = 'flows/:flow';
  static const String routeName = 'PostListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('posts-$flow-flow'),
      providers: [
        BlocProvider(
          create: (_) => ArticleListCubit(
            repository: getIt.get<ArticleRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
            type: ArticleType.post,
            flow: FlowEnum.fromString(flow),
          ),
        ),
        BlocProvider(
          create: (_) => ScrollCubit(),
        ),
        BlocProvider(
          create: (_) => ScaffoldCubit(),
        ),
      ],
      child: const ArticleListView(type: ArticleType.post),
    );
  }
}