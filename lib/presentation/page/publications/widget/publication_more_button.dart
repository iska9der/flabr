import 'package:flutter/material.dart';

import '../../../../data/model/publication/publication.dart';
import '../../../../feature/publication_download/publication_download.dart';

class PublicationMoreButton extends StatelessWidget {
  const PublicationMoreButton({super.key, required this.publication});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PublicationDownload(
            publicationId: publication.id,
            publicationText: publication.textHtml,
          ),
        ],
      ),
    );
  }
}
