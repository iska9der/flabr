import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../enhancement/scaffold/scaffold.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../publication/model/flow_enum.dart';
import '../../publication/model/publication_type.dart';
import '../../publication/repository/publication_repository.dart';
import '../../settings/repository/language_repository.dart';
import '../cubit/article_list_cubit.dart';
import 'article_list_page.dart';

@RoutePage(name: NewsListPage.routeName)
class NewsListPage extends StatelessWidget {
  const NewsListPage({
    super.key,
    @PathParam() required this.flow,
  });

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
          create: (_) => ArticleListCubit(
            repository: getIt.get<PublicationRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
            type: PublicationType.news,
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
      child: const ArticleListView(type: PublicationType.news),
    );
  }
}
