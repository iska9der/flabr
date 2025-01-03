import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/component/di/injector.dart';
import '../../../data/model/loading_status_enum.dart';
import '../../../data/model/publication/publication_source_enum.dart';
import '../../../data/model/publication/publication_type_enum.dart';
import '../../utils/utils.dart';
import 'bloc/publication_vote_bloc.dart';
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
          create: (_) => PublicationDetailCubit(
            id,
            source: PublicationSource.fromType(type),
            repository: getIt(),
            languageRepository: getIt(),
          ),
        ),
        BlocProvider(create: (_) => PublicationVoteBloc(getIt())),
      ],
      child: BlocListener<PublicationVoteBloc, PublicationVoteState>(
        listener: (context, state) {
          if (state.status == LoadingStatus.failure && state.error != null) {
            getIt<Utils>().showSnack(
              context: context,
              content: Text(state.error!),
            );
          }
        },
        child: const PublicationDetailView(),
      ),
    );
  }
}
