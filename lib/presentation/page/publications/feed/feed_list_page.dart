import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../feature/scroll/part.dart';
import '../widget/publication_list_view.dart';
import 'cubit/feed_publication_list_cubit.dart';
import 'widget/feed_list_appbar.dart';

@RoutePage(name: FeedListPage.routeName)
class FeedListPage extends StatelessWidget {
  const FeedListPage({super.key});

  static const String name = 'Моя лента';
  static const String routePath = 'feed';
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
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit(),
        ),
      ],
      child: const PublicationListView<FeedPublicationListCubit,
          FeedPublicationListState>(
        appBar: FeedListAppBar(),
      ),
    );
  }
}
