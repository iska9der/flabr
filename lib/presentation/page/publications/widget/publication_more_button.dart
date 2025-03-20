import 'package:flutter/material.dart';

import '../../../../data/model/publication/publication.dart';
import '../../../../feature/publication_download/publication_download.dart';
import '../../../theme/theme.dart';

class PublicationMoreButton extends StatelessWidget {
  const PublicationMoreButton({super.key, required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return TextButtonTheme(
      data: const TextButtonThemeData(
        style: ButtonStyle(alignment: Alignment.centerLeft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
