import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/injector.dart';
import '../../../enhancement/scroll/cubit/scroll_cubit.dart';
import '../../../settings/repository/language_repository.dart';
import '../../cubit/flow_publication_list_cubit.dart';
import '../../model/flow_enum.dart';
import '../../repository/publication_repository.dart';
import '../../widget/appbar/flow_list_appbar.dart';
import '../view/publication_list_view.dart';

@RoutePage(name: ArticleListPage.routeName)
class ArticleListPage extends StatelessWidget {
  const ArticleListPage({super.key, @PathParam() required this.flow});

  final String flow;

  static const String name = 'Статьи';
  static const String routePath = 'flows/:flow';
  static const String routeName = 'ArticleListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('articles-$flow-flow'),
      providers: [
        BlocProvider(
          create: (_) => FlowPublicationListCubit(
            repository: getIt.get<PublicationRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
            flow: FlowEnum.fromString(flow),
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit(),
        ),
      ],
      child: const PublicationListView<FlowPublicationListCubit,
          FlowPublicationListState>(
        appBar: FlowListAppBar(),
      ),
    );
  }
}
