import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/publication/publication.dart';
import '../../../../data/model/section_enum.dart';
import '../../../../di/di.dart';
import '../../../../feature/publication_list/publication_list.dart';
import '../../../../feature/scaffold/scaffold.dart';
import '../../../../feature/scroll/scroll.dart';
import '../cubit/flow_publication_list_cubit.dart';
import '../widget/publication_filters_widget.dart';

@RoutePage(name: PostListPage.routeName)
class PostListPage extends StatelessWidget {
  const PostListPage({super.key, @PathParam() required this.flow});

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
          create:
              (_) => FlowPublicationListCubit(
                repository: getIt(),
                languageRepository: getIt(),
                storage: getIt(instanceName: 'sharedStorage'),
                section: Section.post,
                flow: PublicationFlow.fromString(flow),
              ),
        ),
        BlocProvider(create: (_) => ScrollCubit()),
        BlocProvider(create: (_) => ScaffoldCubit()),
      ],
      child: const PublicationListScaffold<
        FlowPublicationListCubit,
        FlowPublicationListState
      >(filter: PublicationFiltersWidget()),
    );
  }
}
