import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/publication/flow_publication_list_cubit.dart';
import '../../../../bloc/publication/publication_bookmarks_bloc.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../data/model/section_enum.dart';
import '../../../../di/di.dart';
import '../../../../feature/publication_list/publication_list.dart';
import '../../../../feature/scaffold/scaffold.dart';
import '../../../../feature/scroll/scroll.dart';
import '../widget/publication_filters_widget.dart';

@RoutePage(name: NewsListPage.routeName)
class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key, @PathParam() required this.flow});

  final String flow;

  static const String name = 'Новости';
  static const String routePath = 'flows/:flow';
  static const String routeName = 'NewsListRoute';

  @override
  Widget build(BuildContext context) {
    final cubit = FlowPublicationListCubit(
      repository: getIt(),
      languageRepository: getIt(),
      storage: getIt(instanceName: 'sharedStorage'),
      section: Section.news,
      flow: PublicationFlow.fromString(flow),
    );

    return MultiBlocProvider(
      key: ValueKey('news-$flow-flow'),
      providers: [
        BlocProvider.value(value: cubit),
        BlocProvider(
          create: (_) => PublicationBookmarksBloc(repository: getIt()),
        ),
        BlocProvider(create: (_) => ScrollCubit()),
        BlocProvider(create: (_) => ScaffoldCubit()),
      ],
      child: PublicationListScaffold(
        bloc: cubit,
        filter: const PublicationFiltersWidget(),
      ),
    );
  }
}
