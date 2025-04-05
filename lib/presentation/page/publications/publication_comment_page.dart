import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/publication/comment_list_cubit.dart';
import '../../../data/model/publication/publication.dart';
import '../../../di/di.dart';
import 'widget/comment_list_view.dart';

@RoutePage(name: PublicationCommentPage.routeName)
class PublicationCommentPage extends StatelessWidget {
  PublicationCommentPage({
    super.key,
    @PathParam.inherit() required String type,
    @PathParam.inherit() required this.id,
  }) : type = PublicationType.fromString(type);

  final PublicationType type;
  final String id;

  static const String routePath = 'comments';
  static const String routeName = 'PublicationCommentRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('publication-$id-comments'),
      providers: [
        BlocProvider(
          create:
              (_) => CommentListCubit(
                id,
                source: PublicationSource.fromType(type),
                repository: getIt(),
                languageRepository: getIt(),
              ),
        ),
      ],
      child: const CommentListView(),
    );
  }
}
