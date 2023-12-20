import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/di/dependencies.dart';
import '../../../settings/repository/language_repository.dart';
import '../../cubit/comment/comment_hidden_cubit.dart';
import '../../cubit/comment/comment_list_cubit.dart';
import '../../model/source/publication_source.dart';
import '../../repository/publication_repository.dart';
import '../view/comment_list_view.dart';

@RoutePage(name: 'ArticleCommentsRoute')
class ArticleCommentListPage extends StatelessWidget {
  const ArticleCommentListPage({
    super.key,
    @PathParam() required this.id,
  });

  final String id;

  static const routePath = 'comments/:id';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CommentListCubit(
            id,
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
