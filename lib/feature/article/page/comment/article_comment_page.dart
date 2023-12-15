import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/dependencies.dart';
import '../../../publication/cubit/comment/comment_hidden_cubit.dart';
import '../../../publication/cubit/comment/comment_list_cubit.dart';
import '../../../publication/model/source/publication_source.dart';
import '../../../publication/repository/publication_repository.dart';
import '../../../publication/view/comment_list_view.dart';
import '../../../settings/repository/language_repository.dart';

@RoutePage(name: ArticleCommentListPage.routeName)
class ArticleCommentListPage extends StatelessWidget {
  const ArticleCommentListPage({
    super.key,
    @PathParam() required this.articleId,
  });

  final String articleId;

  static const routePath = 'comments/:articleId';
  static const routeName = 'ArticleCommentListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CommentListCubit(
            articleId,
            source: PublicationSource.article,
            repository: getIt.get<PublicationRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
          ),
        ),
        BlocProvider(create: (_) => CommentHiddenCubit()),
      ],
      child: const CommentListView(),
    );
  }
}
