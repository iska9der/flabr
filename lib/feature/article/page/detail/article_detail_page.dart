import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/dependencies.dart';
import '../../../publication/cubit/publication_detail_cubit.dart';
import '../../../publication/model/source/publication_source.dart';
import '../../../publication/repository/publication_repository.dart';
import '../../../publication/view/publication_detail_view.dart';
import '../../../settings/repository/language_repository.dart';

@RoutePage(name: ArticleDetailPage.routeName)
class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({
    super.key,
    @PathParam() required this.id,
  });

  final String id;

  static const String routePath = 'details/:id';
  static const String routeName = 'ArticleDetailRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('article-$id-detail'),
      create: (c) => PublicationDetailCubit(
        id,
        source: PublicationSource.article,
        repository: getIt.get<PublicationRepository>(),
        languageRepository: getIt.get<LanguageRepository>(),
      ),
      child: const PublicationDetailView(),
    );
  }
}
