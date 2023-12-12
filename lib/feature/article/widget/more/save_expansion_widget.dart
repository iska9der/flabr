import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../publication/model/download/format.dart';
import '../../cubit/article_download_cubit.dart';
import '../../model/article_model.dart';

class SaveExpansionWidget extends StatelessWidget {
  const SaveExpansionWidget({super.key, required this.article});

  final ArticleModel article;

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
              create: (_) => ArticleDownloadCubit(
                article: article,
                format: PublicationDownloadFormat.markdown,
              ),
              child: const Expanded(
                child: _SaveButton(label: 'Markdown'),
              ),
            ),
            const SizedBox(width: 16),
            BlocProvider(
              create: (_) => ArticleDownloadCubit(
                article: article,
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
    return BlocBuilder<ArticleDownloadCubit, ArticleDownloadState>(
      builder: (context, state) {
        return OutlinedButton.icon(
          icon: const Icon(Icons.save_alt_rounded),
          label: switch (state.status) {
            ArticleDownloadStatus.success => const Text('Сохранено'),
            ArticleDownloadStatus.notSupported => const Text('Недоступно'),
            _ => Text(label),
          },
          onPressed: switch (state.status) {
            ArticleDownloadStatus.notSupported ||
            ArticleDownloadStatus.loading ||
            ArticleDownloadStatus.success =>
              null,
            _ => () => context.read<ArticleDownloadCubit>().pickAndSave(),
          },
        );
      },
    );
  }
}
