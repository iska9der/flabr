import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/publication_download_cubit.dart';
import '../../model/download/format.dart';
import '../../model/publication/publication.dart';

class SaveExpansionWidget extends StatelessWidget {
  const SaveExpansionWidget({super.key, required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: const Text('Сохранить статью'),
      tilePadding: EdgeInsets.zero,
      childrenPadding: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocProvider(
              create: (_) => PublicationDownloadCubit(
                publication: publication,
                format: PublicationDownloadFormat.markdown,
              ),
              child: const Expanded(
                child: _SaveButton(label: 'Markdown'),
              ),
            ),
            const SizedBox(width: 16),
            BlocProvider(
              create: (_) => PublicationDownloadCubit(
                publication: publication,
                format: PublicationDownloadFormat.html,
              ),
              child: const Expanded(
                child: _SaveButton(label: 'HTML'),
              ),
            )
          ],
        )
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PublicationDownloadCubit, PublicationDownloadState>(
      builder: (context, state) {
        return OutlinedButton.icon(
          icon: const Icon(Icons.save_alt_rounded),
          label: switch (state.status) {
            PublicationDownloadStatus.success => const Text('Сохранено'),
            PublicationDownloadStatus.notSupported => const Text('Недоступно'),
            _ => Text(label),
          },
          onPressed: switch (state.status) {
            PublicationDownloadStatus.notSupported ||
            PublicationDownloadStatus.loading ||
            PublicationDownloadStatus.success =>
              null,
            _ => () => context.read<PublicationDownloadCubit>().pickAndSave(),
          },
        );
      },
    );
  }
}
