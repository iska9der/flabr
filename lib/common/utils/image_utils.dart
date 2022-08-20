import 'package:flutter/material.dart';

import '../../config/constants.dart';
import '../widget/progress_indicator.dart';

class ImageUtils {
  Widget placeholder(BuildContext context, String url) => const SizedBox(
        height: postImageHeight,
        child: CircleIndicator.small(),
      );
}
