import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../data/model/publication/publication.dart';
import '../../../../../extension/context.dart';
import '../../../../../extension/theme.dart';
import '../../../../../widget/user_text_button.dart';

class PublicationHeaderWidget extends StatelessWidget {
  const PublicationHeaderWidget(this.publication, {super.key});

  final Publication publication;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserTextButton(
          publication.author,
          subtitle: Text(
            DateFormat.yMMMMd().add_jm().format(publication.publishedAt),
            style:
                Theme.of(
                  context,
                ).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.w500,
                  color: context.theme.colors.shady,
                ),
          ),
        ),
      ],
    );
  }
}
