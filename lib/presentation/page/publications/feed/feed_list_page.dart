import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../feature/publication_list/publication_list.dart';
import '../../../../feature/scroll/scroll.dart';
import 'cubit/feed_publication_list_cubit.dart';
import 'widget/feed_filters_widget.dart';

@RoutePage(name: FeedListPage.routeName)
class FeedListPage extends StatelessWidget {
  const FeedListPage({super.key});

  static const String name = 'Моя лента';
  static const String routePath = '';
  static const String routeName = 'FeedListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: const ValueKey('feed-list'),
      providers: [
        BlocProvider(
          create: (_) => FeedPublicationListCubit(
            repository: getIt(),
            languageRepository: getIt(),
            storage: getIt(instanceName: 'sharedStorage'),
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit(),
        ),
      ],
      child: const PublicationListScaffold<FeedPublicationListCubit,
          FeedPublicationListState>(
        filter: FeedFiltersWidget(),
      ),
    );
  }
}
