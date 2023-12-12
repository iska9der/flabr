import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/dependencies.dart';
import '../../../publication/model/source/publication_source.dart';
import '../../../publication/repository/publication_repository.dart';
import '../../../publication/view/publication_detail_view.dart';
import '../../../settings/repository/language_repository.dart';
import '../../cubit/article_cubit.dart';

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
      create: (c) => ArticleCubit(
        id,
        source: PublicationSource.news,
        repository: getIt.get<PublicationRepository>(),
        languageRepository: getIt.get<LanguageRepository>(),
      ),
      child: const PublicationDetailView(),
    );
  }
}
