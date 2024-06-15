import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../data/model/publication/publication_source_enum.dart';
import '../cubit/comment_list_cubit.dart';
import '../widget/comment_list_view.dart';

class PostCommentListPage extends StatelessWidget {
  const PostCommentListPage({super.key, required this.id});

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
