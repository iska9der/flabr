import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../data/model/publication/publication_source_enum.dart';
import '../cubit/publication_detail_cubit.dart';
import '../widget/publication_detail_view.dart';

class PostDetailPage extends StatelessWidget {
  const PostDetailPage({
    super.key,
    required this.id,
  });

  final String id;

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
