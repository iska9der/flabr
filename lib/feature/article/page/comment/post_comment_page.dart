import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/dependencies.dart';
import '../../../settings/repository/language_repository.dart';
import '../../cubit/comment_hidden_cubit.dart';
import '../../cubit/comment_list_cubit.dart';
import '../../model/helper/article_source.dart';
import '../../repository/article_repository.dart';
import 'article_comment_page.dart';

@RoutePage(name: PostCommentListPage.routeName)
class PostCommentListPage extends StatelessWidget {
  const PostCommentListPage({
    super.key,
    @PathParam() required this.articleId,
  });

  final String articleId;

  static const routePath = 'comments/:articleId';
  static const routeName = 'PostCommentListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CommentListCubit(
            articleId,
            source: ArticleSource.post,
            repository: getIt.get<ArticleRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
          ),
        ),
        BlocProvider(create: (_) => CommentHiddenCubit()),
      ],
      child: const CommentListView(),
    );
  }
}
