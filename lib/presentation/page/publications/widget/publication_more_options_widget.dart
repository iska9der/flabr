import 'package:flutter/material.dart';

import '../../../../data/model/publication/publication.dart';
import '../../../feature/publication_download/part.dart';
import '../../../theme/theme.dart';

class PublicationMoreOptions extends StatelessWidget {
  const PublicationMoreOptions({super.key, required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return TextButtonTheme(
      data: const TextButtonThemeData(
        style: ButtonStyle(alignment: Alignment.centerLeft),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kScreenHPadding),
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
