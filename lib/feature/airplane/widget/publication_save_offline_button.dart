import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/publication/publication.dart';
import '../../../presentation/extension/extension.dart';
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
    return BlocListener<OfflinePublicationBloc, OfflinePublicationState>(
      listenWhen: (previous, current) =>
          previous.operationError != current.operationError &&
          current.operationErrorId == publication.id &&
          current.operationError != null,
      listener: (context, state) {
        context.showSnack(content: Text(state.operationError!));
      },
      child:
          BlocSelector<
            OfflinePublicationBloc,
            OfflinePublicationState,
            ({bool saved, bool loading})
          >(
            selector: (state) => (
              saved: state.savedIds.contains(publication.id),
              loading: state.loadingIds.contains(publication.id),
            ),
            builder: (context, value) {
              final exists = value.saved;
              final isLoading = value.loading;

              return FilledButton.tonalIcon(
                label: Text(exists ? 'Удалить из оффлайна' : label),
                icon: switch (isLoading) {
                  true => const CircleIndicator.small(),
                  false => Icon(
                    exists ? Icons.bookmark : Icons.bookmark_border,
                  ),
                },
                onPressed: switch (isLoading) {
                  true => null,
                  false => () => context.read<OfflinePublicationBloc>().add(
                    OfflinePublicationEvent.setSaved(
                      publication: publication,
                      saved: !exists,
                    ),
                  ),
                },
              );
            },
          ),
    );
  }
}
