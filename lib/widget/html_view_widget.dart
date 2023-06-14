import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:path/path.dart' as p;

import '../../component/di/dependencies.dart';
import '../../component/router/app_router.dart';
import '../../widget/extension/extension.dart';
import '../config/constants.dart';
import '../feature/settings/cubit/settings_cubit.dart';
import 'image/network_image_widget.dart';
import 'progress_indicator.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({
    super.key,
    required this.textHtml,
    this.renderMode = RenderMode.sliverList,
    this.customWidgetBuilder,
    this.padding = const EdgeInsets.only(left: 20, right: 20, bottom: 40),
  });

  final String textHtml;
  final RenderMode renderMode;
  final CustomWidgetBuilder? customWidgetBuilder;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        var articleConfig = state.articleConfig;
        var isImageVisible = articleConfig.isImagesVisible;
        var fontSize = Theme.of(context).textTheme.bodyLarge!.fontSize! *
            articleConfig.fontScale;

        return HtmlWidget(
          textHtml,
          renderMode: renderMode,
          rebuildTriggers: RebuildTriggers([
            Theme.of(context).brightness,
            fontSize,
            isImageVisible,
          ]),
          onTapUrl: (String url) async {
            await getIt.get<AppRouter>().pushArticleOrExternal(Uri.parse(url));

            return true;
          },
          onLoadingBuilder: (ctx, el, prgrs) => const CircleIndicator.small(),
          factoryBuilder: () => CustomFactory(context),
          customStylesBuilder: (element) {
            if (element.localName == 'div' && element.parent == null) {
              return {
                'margin-left': '${padding.left}px',
                'margin-right': '${padding.right}px',
                'padding-bottom': '${padding.bottom}px',
                'font-size': '${fontSize}px',
              };
            }

            return null;
          },
          customWidgetBuilder: customWidgetBuilder ??
              (element) {
                if (element.localName == 'img') {
                  if (!isImageVisible) return const Wrap();

                  String imgSrc = element.attributes['data-src'] ??
                      element.attributes['src'] ??
                      '';

                  if (imgSrc.isEmpty) {
                    return null;
                  }

                  String imgExt = p.extension(imgSrc);

                  if (imgExt == '.svg') return null;

                  return Align(
                    child: NetworkImageWidget(
                      imageUrl: imgSrc,
                      height: kImageHeightDefault,
                      isTapable: true,
                    ),
                  );
                }

                return null;
              },
        );
      },
    );
  }
}

class CustomFactory extends WidgetFactory with SvgFactory, WebViewFactory {
  CustomFactory(this.context);

  final BuildContext context;

  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;

  @override
  Widget? buildImageWidget(BuildMetadata meta, ImageSource src) {
    /// меняем цвет выделения svg
    SvgPicture? widget = super.buildImageWidget(meta, src) as SvgPicture?;

    widget = widget?.copyWith(
      colorFilter: ColorFilter.mode(
        Theme.of(context).textTheme.bodyMedium!.color!,
        BlendMode.srcIn,
      ),
    );

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

        /// если родитель не "pre", то это инлайновый фрагмент кода
        if (el.parent?.localName != 'pre') {
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
        final op = BuildOp(
          onTree: (_, tree) {
            WidgetBit.block(
              tree.parent!,
              buildBlockCodeWidget(el.text),
            ).insertBefore(tree);

            tree.detach();
          },
        );
        meta.register(op);
        break;
    }

    return super.parse(meta);
  }

  Widget buildBlockCodeWidget(String text) {
    ScrollController controller = ScrollController();

    return DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
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
      ),
    );
  }

  Widget buildInlineCodeWidget(String text) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SelectableText(text),
    );
  }
}
