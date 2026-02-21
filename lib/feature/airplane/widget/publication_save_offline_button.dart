import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/publication/publication.dart';
import '../../../presentation/widget/enhancement/enhancement.dart';
import '../bloc/bloc.dart';

class PublicationSaveOfflineButton extends StatelessWidget {
  const PublicationSaveOfflineButton({
    super.key,
    required this.publication,
    this.label = 'Сохранить оффлайн',
  });

  final Publication publication;
  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfflinePublicationBloc, OfflinePublicationState>(
      builder: (context, state) {
        final exists = state.idsInDb.contains(publication.id);
        final isLoading = state.loadingIds.contains(publication.id);

        return FilledButton.icon(
          label: Text(label),
          icon: switch (isLoading) {
            true => const CircleIndicator.small(),
            false => Icon(exists ? Icons.bookmark : Icons.bookmark_border),
          },
          onPressed: switch (isLoading) {
            true => null,
            false => () => context.read<OfflinePublicationBloc>().add(
              OfflinePublicationEvent.toggle(publication),
            ),
          },
        );
      },
    );
  }
}
