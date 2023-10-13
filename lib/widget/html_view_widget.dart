import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:path/path.dart' as p;

import '../../component/di/dependencies.dart';
import '../../component/router/app_router.dart';
import '../config/constants.dart';
import '../feature/settings/cubit/settings_cubit.dart';
import 'extension/extension.dart';
import 'image/network_image_widget.dart';
import 'progress_indicator.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({
    super.key,
    required this.textHtml,
    this.renderMode = RenderMode.sliverList,
    this.padding = const EdgeInsets.only(left: 20, right: 20, bottom: 40),
  });

  final String textHtml;
  final RenderMode renderMode;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final articleConfig = state.articleConfig;
        final isImageVisible = articleConfig.isImagesVisible;
        final fontSize =
            theme.textTheme.bodyLarge!.fontSize! * articleConfig.fontScale;
        final isWebViewEnabled = articleConfig.webViewEnabled;

        return HtmlWidget(
          textHtml,
          renderMode: renderMode,
          rebuildTriggers: RebuildTriggers([
            Theme.of(context).brightness,
            fontSize,
            isImageVisible,
            isWebViewEnabled,
          ]),
          onTapUrl: (String url) async {
            await getIt.get<AppRouter>().pushArticleOrExternal(Uri.parse(url));

            return true;
          },
          onErrorBuilder: (context, element, error) =>
              Text('$element error: $error'),
          onLoadingBuilder: (ctx, el, prgrs) => const CircleIndicator.medium(),
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
          customWidgetBuilder: (element) {
            if (element.localName == 'img') {
              /// Если пользователь не хочет видеть изображения - не показываем
              if (!isImageVisible) {
                return const SizedBox();
              }

              /// Люди верстают статьи по-разному, и иногда ужасно:
              /// https://habr.com/ru/articles/599753/
              /// почти все элементы находятся под одним родителем,
              /// и поэтому, если мы уберем это условие, иконки подзаголовков
              /// будут рендериться на отдельной строке, а по факту нужно инлайн.
              /// Пусть библиотека сама разбирается с такими случаями.
              if (element.parent != null &&
                  element.parent!.children.length > 1 &&
                  element.parent!.localName != 'figure' &&
                  element.nextElementSibling?.localName != 'br') {
                return null;
              }

              final imgSrc = element.attributes['data-src'] ??
                  element.attributes['src'] ??
                  '';
              if (imgSrc.isEmpty) {
                return null;
              }

              String imgExt = p.extension(imgSrc);
              if (imgExt == '.svg') return null;

              Widget widget = NetworkImageWidget(
                imageUrl: imgSrc,
                height: kImageHeightDefault,
                isTapable: true,
              );

              final semanticLabel =
                  element.attributes['alt'] ?? element.attributes['title'];
              if (semanticLabel != null) {
                widget = Semantics(
                  label: semanticLabel,
                  image: true,
                  child: widget,
                );
              }

              final tooltip = element.attributes['title'];
              if (tooltip != null) {
                widget = Tooltip(
                  message: tooltip,
                  child: widget,
                );
              }

              widget = Align(child: widget);

              return widget;
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
  bool get webView => true;
  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;

  @override
  Widget? buildImageWidget(BuildMetadata meta, ImageSource src) {
    Widget? widget = super.buildImageWidget(meta, src);
    if (widget is! SvgPicture) {
      return widget;
    }

    widget = widget.copyWith(
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

    final isWebViewEnabled =
        context.read<SettingsCubit>().state.articleConfig.webViewEnabled;

    switch (el.localName) {
      case 'div':
        if (el.className.contains('tm-iframe_temp')) {
          final op = BuildOp(
            onWidgets: (meta, widgets) {
              String src = el.attributes['data-src'] ?? '';
              final attrs = meta.element.attributes;

              final widget = isWebViewEnabled
                  ? buildWebView(
                      meta,
                      src,
                      height: tryParseDoubleFromMap(attrs, 'height'),
                      sandbox: attrs['sanbox']?.split(RegExp(r'\s+')),
                      width: tryParseDoubleFromMap(attrs, 'width'),
                    )
                  : buildWebViewLinkOnly(meta, src);

              return listOrNull(widget) ?? widgets;
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
