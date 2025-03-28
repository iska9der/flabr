import 'package:flutter/material.dart';

import '../../feature/image_action/image_action.dart';
import '../theme/theme.dart';

class CardAvatarWidget extends StatelessWidget {
  const CardAvatarWidget({
    super.key,
    required this.imageUrl,
    this.height = AppDimensions.avatarHeight,
    this.placeholderColor,
  });

  final String imageUrl;
  final double height;
  final Color? placeholderColor;

  Widget onLoading(BuildContext context, String url) =>
      _PlaceholderAvatar(height: height, color: placeholderColor);

  Widget onError(BuildContext context, String url, error) =>
      _PlaceholderAvatar(height: height, color: placeholderColor);

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? ClipRRect(
          clipBehavior: Clip.hardEdge,
          borderRadius: AppStyles.borderRadius,
          child: NetworkImageWidget(
            imageUrl: 'https:$imageUrl',
            height: height,
            loadingWidget: onLoading,
            errorWidget: onError,
          ),
        )
        : _PlaceholderAvatar(height: height, color: placeholderColor);
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  const _PlaceholderAvatar({this.height, this.color});

  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Icon(
        Icons.account_circle,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        size: height,
      ),
    );
  }
}
