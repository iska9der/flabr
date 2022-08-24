import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:path/path.dart' as p;

import '../../common/utils/utils.dart';
import '../../common/widget/extension/extension.dart';
import '../../common/widget/network_image_widget.dart';
import '../../component/di/dependencies.dart';
import 'progress_indicator.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({Key? key, required this.textHtml}) : super(key: key);

  final String textHtml;

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      textHtml,
      key: ValueKey(Theme.of(context).brightness),
      renderMode: RenderMode.sliverList,
      onTapUrl: (url) async => await getIt.get<Utils>().launcher.launchUrl(url),
      onLoadingBuilder: (ctx, el, prgrs) => const CircleIndicator.small(),
      factoryBuilder: () => CustomFactory(context),
      customStylesBuilder: ((element) {
        if (element.localName == 'div' && element.parent == null) {
          return {'margin-left': '20px', 'margin-right': '20px'};
        }

        return null;
      }),
      customWidgetBuilder: (element) {
        if (element.localName == 'img') {
          String imgSrc =
              element.attributes['data-src'] ?? element.attributes['src'] ?? '';

          if (imgSrc.isEmpty) {
            return null;
          }

          String imgExt = p.extension(imgSrc);

          if (imgExt == '.svg') return null;

          return Align(
            child: NetworkImageWidget(
              imageUrl: imgSrc,
              isTapable: true,
            ),
          );
        }

        return null;
      },
    );
  }
}

class CustomFactory extends WidgetFactory
    with SelectableTextFactory, SvgFactory, WebViewFactory {
  CustomFactory(this.context);

  final BuildContext context;

  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;

  @override
  Widget? buildImageWidget(BuildMetadata meta, ImageSource src) {
    /// меняем цвет выделения svg
    SvgPicture? widget = super.buildImageWidget(meta, src) as SvgPicture?;

    widget = widget?.copyWith(
        theme: SvgTheme(
      currentColor: Theme.of(context).colorScheme.onSurface,
    ));

    return widget ?? super.buildImageWidget(meta, src);
  }

  @override
  void parse(BuildMetadata meta) {
    final el = meta.element;

    switch (el.localName) {
      case 'div':
        if (el.className.contains('tm-iframe_temp')) {
          final op = BuildOp(
            onWidgets: (meta, widgets) {
              String src = el.attributes['data-src'] ?? '';
              final attrs = meta.element.attributes;

              return listOrNull(
                    buildWebView(
                      meta,
                      src,
                      height: tryParseDoubleFromMap(attrs, 'height'),
                      sandbox: attrs['sanbox']?.split(RegExp(r'\s+')),
                      width: tryParseDoubleFromMap(attrs, 'width'),
                    ),
                  ) ??
                  widgets;
            },
          );
          meta.register(op);
        }
        break;
      case 'code':

        /// если родитель "p", то это инлайновый фрагмент кода,
        /// плагин сам его обработает
        /// todo: добавить обводку
        if (el.parent?.localName == 'p') {
          final op = BuildOp(
            onTree: (meta, tree) {
              tree.bits.firstWhere((element) => element.tsb == tree.tsb);
              WidgetBit.inline(tree.parent!, buildInlineCodeWidget(el.text))
                  .insertBefore(tree);

              tree.detach();
            },
          );
          meta.register(op);
          break;
        }

        meta.register(
          BuildOp(
            onTree: (_, tree) {
              tree.bits.firstWhere((element) => element.tsb == tree.tsb);
              WidgetBit.block(
                tree.parent!,
                buildBlockCodeWidget(el.text),
              ).insertBefore(tree);

              tree.detach();
            },
          ),
        );

        break;
    }

    return super.parse(meta);
  }

  Container buildBlockCodeWidget(String text) {
    final ScrollController controller = ScrollController();

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
      ),
      child: Scrollbar(
        controller: controller,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: controller,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          child: SelectableText(text),
        ),
      ),
    );
  }

  Container buildInlineCodeWidget(String text) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SelectableText(text),
    );
  }
}
