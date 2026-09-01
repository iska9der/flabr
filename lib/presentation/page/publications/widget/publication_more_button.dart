import 'package:flutter/material.dart';

import '../../../../data/model/publication/publication.dart';
import '../../../../feature/airplane/airplane.dart';
import '../../../../feature/publication_download/publication_download.dart';
import '../../../../i18n/i18n.dart';
import '../../../extension/extension.dart';

class PublicationMoreButton extends StatelessWidget {
  const PublicationMoreButton({super.key, required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: const .fromLTRB(12, 0, 12, 16),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            Padding(
              padding: const .fromLTRB(4, 0, 4, 12),
              child: Text(
                context.t.publication.actions.title,
                style: context.theme.textTheme.titleMedium,
              ),
            ),
            PublicationSaveOfflineButton(publication: publication),
            const SizedBox(height: 8),
            PublicationDownload(
              publicationId: publication.id,
              publicationText: publication.textHtml,
            ),
          ],
        ),
      ),
    );
  }
}
