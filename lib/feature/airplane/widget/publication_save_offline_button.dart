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
  });

  final Publication publication;

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

              return AppActionTile(
                icon: exists
                    ? Icons.delete_outline_rounded
                    : Icons.offline_pin_outlined,
                title: exists
                    ? 'Удалить офлайн-копию'
                    : 'Сохранить для офлайна',
                subtitle: exists
                    ? 'Статья сохранена на устройстве'
                    : 'Статья и изображения будут доступны без интернета',
                destructive: exists,
                trailing: isLoading ? const CircleIndicator.small() : null,
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
