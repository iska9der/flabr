import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../data/model/publication/publication_source_enum.dart';
import '../cubit/comment_list_cubit.dart';
import '../widget/comment_list_view.dart';

@RoutePage(name: 'NewsCommentsRoute')
class NewsCommentListPage extends StatelessWidget {
  const NewsCommentListPage({
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
            source: PublicationSource.news,
            repository: getIt(),
            languageRepository: getIt(),
          ),
        ),
      ],
      child: const CommentListView(),
    );
  }
}
