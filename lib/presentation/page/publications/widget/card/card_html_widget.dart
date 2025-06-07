import 'package:flutter/widgets.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../../../../../feature/image_action/widget/network_image_widget.dart';
import '../../../../theme/theme.dart';

class CardHtmlWidget extends StatelessWidget {
  const CardHtmlWidget({
    super.key,
    required this.textHtml,
    this.rebuildTriggers,
    this.isImageVisible = true,
  });

  final String textHtml;
  final List<dynamic>? rebuildTriggers;
  final bool isImageVisible;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: HtmlWidget(
        textHtml,
        rebuildTriggers: rebuildTriggers,
        customWidgetBuilder: (element) {
          if (element.localName == 'br') {
            return const SizedBox();
          }

          if (element.localName == 'img') {
            if (!isImageVisible) {
              return const SizedBox();
            }

            String imgSrc =
                element.attributes['data-src'] ??
                element.attributes['src'] ??
                '';

            if (imgSrc.isEmpty) {
              return null;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Align(
                child: NetworkImageWidget(
                  imageUrl: imgSrc,
                  height: AppDimensions.imageHeight,
                  isTapable: true,
                ),
              ),
            );
          }

          return null;
        },
      ),
    );
  }
}
