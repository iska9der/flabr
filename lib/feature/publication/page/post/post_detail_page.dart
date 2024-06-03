import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../cubit/publication_detail_cubit.dart';
import '../../model/source/publication_source.dart';
import '../view/publication_detail_view.dart';

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
      key: ValueKey('post-$id-detail'),
      create: (c) => PublicationDetailCubit(
        id,
        source: PublicationSource.post,
        repository: getIt(),
        languageRepository: getIt(),
      ),
      child: const PublicationDetailView(),
    );
  }
}
