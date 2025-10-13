import 'package:flutter/material.dart';

import '../../feature/image_action/image_action.dart';
import '../theme/theme.dart';

class CardAvatarWidget extends StatelessWidget {
  const CardAvatarWidget({
    super.key,
    required this.imageUrl,
    this.height = AppDimensions.avatarHeight,
    this.placeholderIcon,
    this.placeholderColor,
  });

  final String imageUrl;
  final double height;
  final IconData? placeholderIcon;
  final Color? placeholderColor;

  @override
  Widget build(BuildContext context) {
    final placeholder = _PlaceholderAvatar(
      height: height,
      icon: placeholderIcon,
      color: placeholderColor,
    );

    if (imageUrl.isEmpty) {
      return placeholder;
    }

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: AppStyles.avatarBorderRadius,
      child: NetworkImageWidget(
        imageUrl: 'https:$imageUrl',
        height: height,
        loadingPlaceholder: placeholder,
        errorBuilder: (_, _, _) => placeholder,
      ),
    );
  }
}

class _PlaceholderAvatar extends StatelessWidget {
  const _PlaceholderAvatar({this.height, this.icon, this.color});

  final double? height;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Icon(
        icon ?? AppIcons.authorPlaceholder,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        size: height,
      ),
    );
  }
}
