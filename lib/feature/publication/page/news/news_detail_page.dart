import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/injector.dart';
import '../../../settings/repository/language_repository.dart';
import '../../cubit/publication_detail_cubit.dart';
import '../../model/source/publication_source.dart';
import '../../repository/publication_repository.dart';
import '../view/publication_detail_view.dart';

@RoutePage(name: NewsDetailPage.routeName)
class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({
    super.key,
    @PathParam() required this.id,
  });

  final String id;

  static const String routePath = 'details/:id';
  static const String routeName = 'NewsDetailRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('news-$id-detail'),
      create: (c) => PublicationDetailCubit(
        id,
        source: PublicationSource.news,
        repository: getIt.get<PublicationRepository>(),
        languageRepository: getIt.get<LanguageRepository>(),
      ),
      child: const PublicationDetailView(),
    );
  }
}
