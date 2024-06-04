import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../data/model/publication/publication_flow_enum.dart';
import '../../../../data/model/publication/publication_type_enum.dart';
import '../../../feature/scaffold/part.dart';
import '../../../feature/scroll/part.dart';
import '../cubit/flow_publication_list_cubit.dart';
import '../widget/flow_list_appbar.dart';
import '../widget/publication_list_view.dart';

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
          create: (_) => FlowPublicationListCubit(
            repository: getIt(),
            languageRepository: getIt(),
            type: PublicationType.news,
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
      child: const PublicationListView<FlowPublicationListCubit,
          FlowPublicationListState>(
        appBar: FlowListAppBar(),
      ),
    );
  }
}
