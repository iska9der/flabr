import 'package:flutter/material.dart';

import '../../../../../../core/component/router/router.dart';
import '../../../../../../data/model/publication/publication.dart';
import '../../../../../../di/di.dart';
import '../../../../../extension/extension.dart';
import '../../../../../theme/theme.dart';

class PostLabelsDataList extends StatelessWidget {
  const PostLabelsDataList({super.key, this.postLabels = const []});

  final List<PostLabel> postLabels;

  @override
  Widget build(BuildContext context) {
    if (postLabels.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: postLabels
          .map(
            (label) => switch (label.typeEnum) {
              PostLabelType.translation => _TranslationLabelWidget(label),
              _ => const SizedBox(),
            },
          )
          .toList(),
    );
  }
}

class _TranslationLabelWidget extends StatelessWidget {
  const _TranslationLabelWidget(this.label);

  final PostLabel label;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final radius = AppStyles.buttonBorderRadius;
    final text = label.data.originalAuthorName != null
        ? 'Автор оригинала: ${label.data.originalAuthorName}'
        : 'Ссылка на оригинал';

    return Material(
      color: theme.colors.card,
      borderRadius: radius,
      child: InkWell(
        borderRadius: radius,
        onTap: switch (label.data.originalUrl) {
          String url => () => getIt<AppRouter>().launchUrl(url),
          null => null,
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(
            text,
            style: TextStyle(color: theme.colors.deluge),
          ),
        ),
      ),
    );
  }
}
