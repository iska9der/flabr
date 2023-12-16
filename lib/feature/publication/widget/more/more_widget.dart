import 'package:flutter/material.dart';

import '../../../../config/constants.dart';
import '../../model/publication.dart';
import 'save_expansion_widget.dart';

class PublicationMoreWidget extends StatelessWidget {
  const PublicationMoreWidget({super.key, required this.publication});

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
            SaveExpansionWidget(publication: publication),
          ],
        ),
      ),
    );
  }
}
