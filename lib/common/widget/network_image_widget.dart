import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../component/di/dependencies.dart';
import '../utils/utils.dart';

class NetworkImageWidget extends StatelessWidget {
  const NetworkImageWidget({
    Key? key,
    required this.url,
    this.height,
  }) : super(key: key);

  final String url;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      height: height,
      placeholder: getIt.get<Utils>().image.onLoading,
      errorWidget: getIt.get<Utils>().image.onError,
    );
  }
}
