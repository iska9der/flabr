import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/dependencies.dart';
import '../../../publication/model/source/publication_source.dart';
import '../../../publication/repository/publication_repository.dart';
import '../../../settings/repository/language_repository.dart';
import '../../cubit/article_cubit.dart';
import 'article_detail_page.dart';

@RoutePage(name: PostDetailPage.routeName)
class PostDetailPage extends StatelessWidget {
  const PostDetailPage({
    super.key,
    @PathParam() required this.id,
  });

  final String id;

  static const String routePath = 'details/:id';
  static const String routeName = 'PostDetailRoute';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('posts-$id-detail'),
      create: (c) => ArticleCubit(
        id,
        source: PublicationSource.post,
        repository: getIt.get<PublicationRepository>(),
        languageRepository: getIt.get<LanguageRepository>(),
      ),
      child: const ItemDetailPageView(),
    );
  }
}
