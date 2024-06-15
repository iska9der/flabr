import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/injector.dart';
import '../../../../data/model/publication/publication_source_enum.dart';
import '../cubit/publication_detail_cubit.dart';
import '../widget/publication_detail_view.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: ValueKey('article-$id-detail'),
      create: (c) => PublicationDetailCubit(
        id,
        source: PublicationSource.article,
        repository: getIt(),
        languageRepository: getIt(),
      ),
      child: const PublicationDetailView(),
    );
  }
}
