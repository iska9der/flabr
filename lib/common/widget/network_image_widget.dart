import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../component/di/dependencies.dart';
import '../utils/utils.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    Key? key,
    required this.url,
    this.height,
    this.placeholderWidget,
    this.errorWidget,
  }) : super(key: key);

  final String url;
  final double? height;
  final PlaceholderWidgetBuilder? placeholderWidget;
  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: ValueKey(url),
      imageUrl: url,
      height: height,
      placeholder: placeholderWidget ?? getIt.get<Utils>().image.onLoading,
      errorWidget: errorWidget ?? getIt.get<Utils>().image.onError,
    );
  }
}
