import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../cubit/comment/comment_list_cubit.dart';
import '../../model/source/publication_source.dart';
import '../view/comment_list_view.dart';

@RoutePage(name: 'PostCommentsRoute')
class PostCommentListPage extends StatelessWidget {
  const PostCommentListPage({
    super.key,
    @PathParam() required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CommentListCubit(
            id,
            source: PublicationSource.post,
            repository: getIt(),
            languageRepository: getIt(),
          ),
        ),
      ],
      child: const CommentListView(),
    );
  }
}
