import 'package:flutter/material.dart';

import '../../../config/constants.dart';
import '../../../widget/network_image_widget.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({
    Key? key,
    required this.imageUrl,
    this.height = kAvatarHeight,
  }) : super(key: key);

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
              placeholderWidget: onLoading,
              errorWidget: onError,
            ),
          )
        : const _PlaceholderAvatar();
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  const _PlaceholderAvatar({Key? key}) : super(key: key);

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
