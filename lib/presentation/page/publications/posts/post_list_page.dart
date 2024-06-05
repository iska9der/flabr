import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../data/model/filter/part.dart';
import '../../../../data/model/publication/publication_flow_enum.dart';
import '../../../feature/publication_list/part.dart';
import '../../../feature/scaffold/part.dart';
import '../../../feature/scroll/part.dart';
import '../cubit/flow_publication_list_cubit.dart';
import '../widget/flow_list_appbar.dart';

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
          create: (_) => FlowPublicationListCubit(
            repository: getIt(),
            languageRepository: getIt(),
            type: FlowFilterPublication.post,
            flow: PublicationFlow.fromString(flow),
          ),
        ),
        BlocProvider(
          create: (_) => ScrollCubit(),
        ),
        BlocProvider(
          create: (_) => ScaffoldCubit(),
        ),
      ],
      child: const PublicationListScaffold<FlowPublicationListCubit,
          FlowPublicationListState>(
        appBar: FlowListAppBar(),
      ),
    );
  }
}
