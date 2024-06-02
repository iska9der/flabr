import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/injector.dart';
import '../../../enhancement/scaffold/scaffold.dart';
import '../../../enhancement/scroll/scroll.dart';
import '../../cubit/flow_publication_list_cubit.dart';
import '../../model/flow_enum.dart';
import '../../model/publication_type.dart';
import '../../widget/appbar/flow_list_appbar.dart';
import '../view/publication_list_view.dart';

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
      child: const PublicationListView<FlowPublicationListCubit,
          FlowPublicationListState>(
        appBar: FlowListAppBar(),
      ),
    );
  }
}
