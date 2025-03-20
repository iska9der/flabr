import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/publication_download_cubit.dart';
import '../model/publication_download_format.dart';

class PublicationDownload extends StatelessWidget {
  const PublicationDownload({
    super.key,
    required this.publicationId,
    required this.publicationText,
  });

  final String publicationId;
  final String publicationText;

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
                publicationId: publicationId,
                publicationText: publicationText,
                format: PublicationDownloadFormat.markdown,
              ),
              child: const Expanded(
                child: _SaveButton(label: 'Markdown'),
              ),
            ),
            const SizedBox(width: 16),
            BlocProvider(
              create: (_) => PublicationDownloadCubit(
                publicationId: publicationId,
                publicationText: publicationText,
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
