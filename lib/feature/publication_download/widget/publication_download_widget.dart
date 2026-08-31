import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../di/di.dart';
import '../../../i18n/i18n.dart';
import '../../../presentation/extension/extension.dart';
import '../../../presentation/widget/enhancement/enhancement.dart';
import '../cubit/publication_download_cubit.dart';

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
    return Column(
      mainAxisSize: .min,
      children: [
        BlocProvider(
          create: (_) => PublicationDownloadCubit(
            publicationId: publicationId,
            publicationText: publicationText,
            format: .markdown,
            assetService: getIt(),
          ),
          child: _SaveButton(
            title: context.t.publication.download.markdown.title,
            subtitle: context.t.publication.download.markdown.subtitle,
            icon: Icons.description_outlined,
          ),
        ),
        const SizedBox(height: 8),
        BlocProvider(
          create: (_) => PublicationDownloadCubit(
            publicationId: publicationId,
            publicationText: publicationText,
            format: .html,
            assetService: getIt(),
          ),
          child: _SaveButton(
            title: context.t.publication.download.html.title,
            subtitle: context.t.publication.download.html.subtitle,
            icon: Icons.code_rounded,
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PublicationDownloadCubit, PublicationDownloadState>(
      listenWhen: (previous, current) =>
          previous.status != current.status && current.status == .failure,
      listener: (context, state) {
        context.showSnack(
          content: Text(context.t.errorMessage(state.error)),
        );
      },
      builder: (context, state) {
        return AppActionTile(
          icon: icon,
          title: title,
          subtitle: switch (state.status) {
            .loading => context.t.publication.download.status.preparing,
            .success => context.t.publication.download.status.saved,
            .notSupported => context.t.publication.download.status.notSupported,
            _ => subtitle,
          },
          trailing: switch (state.status) {
            .loading => const CircleIndicator.small(),
            .success => Icon(
              Icons.check_circle_rounded,
              color: context.theme.colorScheme.primary,
            ),
            .notSupported => const Icon(Icons.block_rounded),
            .failure => const Icon(Icons.refresh_rounded),
            _ => const Icon(Icons.download_rounded),
          },
          onPressed: switch (state.status) {
            .notSupported || .loading || .success => null,
            _ => () => context.read<PublicationDownloadCubit>().pickAndSave(),
          },
        );
      },
    );
  }
}
