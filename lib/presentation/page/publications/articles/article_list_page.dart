import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/publication/flow_publication_list_cubit.dart';
import '../../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../di/di.dart';
import '../../../../feature/publication_list/publication_list.dart';
import '../../../../feature/scroll/scroll.dart';
import '../widget/publication_filters_widget.dart';

@RoutePage(name: ArticleListPage.routeName)
class ArticleListPage extends StatelessWidget {
  const ArticleListPage({super.key, @PathParam() required this.flow});

  final String flow;

  static const String name = 'Статьи';
  static const String routePath = 'flows/:flow';
  static const String routeName = 'ArticleListRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = FlowPublicationListCubit(
      repository: getIt(),
      languageRepository: getIt(),
      storage: getIt(instanceName: 'sharedStorage'),
      flow: PublicationFlow.fromString(flow),
    );

    return MultiBlocProvider(
      key: ValueKey('articles-$flow-flow'),
      providers: [
        BlocProvider.value(value: cubit),
        BlocProvider(
          create: (_) => PublicationBookmarksBloc(repository: getIt()),
        ),
        BlocProvider(create: (_) => ScrollCubit()),
      ],
      child: PublicationListScaffold(
        bloc: cubit,
        filter: const PublicationFiltersWidget(),
      ),
    );
  }
}
