import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:path/path.dart' as p;

import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../../config/constants.dart';
import '../../feature/common/image/widget/network_image_widget.dart';
import '../../feature/settings/cubit/settings_cubit.dart';
import 'enhancement/progress_indicator.dart';
import 'extension/extension.dart';

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
        final publicationConfig = state.publicationConfig;
        final isImageVisible = publicationConfig.isImagesVisible;
        final fontSize =
            theme.textTheme.bodyLarge!.fontSize! * publicationConfig.fontScale;
        final isWebViewEnabled = publicationConfig.webViewEnabled;

        return HtmlWidget(
          textHtml,
          renderMode: renderMode,
          rebuildTriggers: [
            Theme.of(context).brightness,
            fontSize,
            isImageVisible,
            isWebViewEnabled,
          ],
          onTapUrl: (String url) async {
            final uri = Uri.tryParse(url);
            if (uri == null) {
              return false;
            }

            /// anchor links обрабатываются самой библиотекой
            if (url.startsWith('#')) {
              return false;
            }

            await getIt.get<AppRouter>().navigateOrLaunchUrl(uri);
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

            if (element.localName == 'code' &&
                element.parent?.localName != 'pre') {
              return {
                'background-color': theme.colorScheme.surface.toHex(),
                'font-weight': '500',
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

  List<String> iframeBanList = [
    'video.yandex.ru/iframe',
  ];

  @override
  Widget? buildImageWidget(BuildTree meta, ImageSource src) {
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
  void parse(BuildTree meta) {
    final element = meta.element;
    final attributes = element.attributes;

    final isWebViewEnabled =
        context.read<SettingsCubit>().state.publicationConfig.webViewEnabled;

    switch (element.localName) {
      case 'div':
        if (element.className.contains('tm-iframe_temp')) {
          final op = BuildOp(
            onRenderBlock: (meta, widgets) {
              String src = attributes['data-src'] ?? attributes['src'] ?? '';
              final isBanned = iframeBanList.any(
                (element) => src.contains(element),
              );
              final attrs = meta.element.attributes;
              final sandboxAttrs = attrs['sanbox'] ?? attrs['sandbox'];
              final widget = isWebViewEnabled && !isBanned
                  ? buildWebView(
                      meta,
                      src,
                      height: tryParseDoubleFromMap(attrs, 'height'),
                      width: tryParseDoubleFromMap(attrs, 'width'),
                      sandbox: sandboxAttrs?.split(RegExp(r'\s+')),
                    )
                  : buildWebViewLinkOnly(meta, src);

              return widget ?? widgets;
            },
          );

          meta.register(op);
        }
        break;
      case 'code':

        /// если родитель не "pre", то это инлайновый фрагмент кода
        /// добавляем стиль с помощью customStylesBuilder
        if (element.parent?.localName != 'pre') {
          break;
        }

        final op = BuildOp(
          onRenderBlock: (tree, placeholder) {
            return buildBlockCodeWidget(element.text);
          },
        );
        meta.register(op);
        break;
    }

    return super.parse(meta);
  }

  Widget buildBlockCodeWidget(String text) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(12),
          child: Text(text),
        ),
      ),
    );
  }
}
