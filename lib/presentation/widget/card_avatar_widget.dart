import 'package:flutter/material.dart';

import '../feature/image_action/part.dart';
import '../theme/theme.dart';

class CardAvatarWidget extends StatelessWidget {
  const CardAvatarWidget({
    super.key,
    required this.imageUrl,
    this.height = kAvatarHeight,
  });

  final String imageUrl;
  final double height;

  Widget onLoading(BuildContext context, String url) =>
      const _PlaceholderAvatar();

  Widget onError(BuildContext context, String url, error) =>
      const _PlaceholderAvatar();

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.all(
              Radius.circular(kBorderRadiusDefault),
            ),
            child: NetworkImageWidget(
              imageUrl: 'https:$imageUrl',
              height: height,
              loadingWidget: onLoading,
              errorWidget: onError,
            ),
          )
        : const _PlaceholderAvatar();
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  const _PlaceholderAvatar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Icon(
        Icons.account_box_rounded,
        color: Theme.of(context).colorScheme.onSurface,
        size: kAvatarHeight,
      ),
    );
  }
}
