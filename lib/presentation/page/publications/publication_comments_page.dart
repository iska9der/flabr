import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/publication/comment_list_cubit.dart';
import '../../../data/model/publication/publication.dart';
import '../../../di/di.dart';
import 'widget/comment_list_view.dart';

@RoutePage(name: PublicationCommentsPage.routeName)
class PublicationCommentsPage extends StatelessWidget {
  PublicationCommentsPage({
    super.key,
    @PathParam.inherit() required String type,
    @PathParam.inherit() required this.id,
    @urlFragment this.initialId,
  }) : type = .fromString(type);

  final PublicationType type;

  /// Идентификатор публикации
  final String id;

  /// Идентификатор комментария, к которому надо проскроллить
  final String? initialId;

  static const String routePath = 'comments';
  static const String routeName = 'PublicationCommentsRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('publication-$id-comments'),
      providers: [
        BlocProvider(
          create: (_) => CommentListCubit(
            id,
            source: .fromType(type),
            repository: getIt(),
            languageRepository: getIt(),
          ),
        ),
      ],
      child: CommentListView(initialId: _parseCommentId(initialId)),
    );
  }

  String? _parseCommentId(String? fragment) {
    if (fragment == null || fragment.isEmpty) {
      return null;
    }

    const prefix = 'comment_';
    if (fragment.startsWith(prefix)) {
      return fragment.substring(prefix.length);
    }

    return fragment;
  }
}
