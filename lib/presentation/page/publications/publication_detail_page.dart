import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/publication/publication.dart';
import '../../../di/di.dart';
import 'cubit/publication_detail_cubit.dart';
import 'widget/publication_detail_view.dart';

@RoutePage(name: PublicationDetailPage.routeName)
class PublicationDetailPage extends StatelessWidget {
  PublicationDetailPage({
    super.key,
    @PathParam.inherit() required String type,
    @PathParam.inherit() required this.id,
  }) : type = PublicationType.fromString(type);

  final PublicationType type;
  final String id;

  static const String routePath = '';
  static const String routeName = 'PublicationDetailRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('publication-$id-detail'),
      providers: [
        BlocProvider(
          create:
              (_) => PublicationDetailCubit(
                id,
                source: PublicationSource.fromType(type),
                repository: getIt(),
                languageRepository: getIt(),
              ),
        ),
      ],
      child: PublicationDetailView(),
    );
  }
}
