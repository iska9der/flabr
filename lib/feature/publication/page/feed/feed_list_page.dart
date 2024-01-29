import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/dependencies.dart';
import '../../../enhancement/scroll/cubit/scroll_cubit.dart';
import '../../../settings/repository/language_repository.dart';
import '../../cubit/feed_publication_list_cubit.dart';
import '../../cubit/publication_list_cubit.dart';
import '../../repository/publication_repository.dart';
import '../../widget/appbar/feed_list_appbar.dart';
import '../view/publication_list_view.dart';

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
            repository: getIt.get<PublicationRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit(),
        ),
      ],
      child: const PublicationListView<FeedPublicationListCubit,
          PublicationListState>(
        appBar: FeedListAppBar(),
      ),
    );
  }
}
