import 'package:flutter/material.dart';

import '../../../common/widget/network_image_widget.dart';
import '../../../config/constants.dart';

class UserAvatarWidget extends StatelessWidget {
  const UserAvatarWidget({Key? key, required this.imageUrl}) : super(key: key);

  final String imageUrl;

  Widget onLoading(BuildContext context, String url) =>
      const _PlaceholderAvatar();

  Widget onError(BuildContext context, String url, error) =>
      const _PlaceholderAvatar();

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? NetworkImageWidget(
            imageUrl: 'https:$imageUrl',
            height: kAvatarHeight,
            placeholderWidget: onLoading,
            errorWidget: onError,
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
