import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:path/path.dart' as p;

import '../../core/component/di/injector.dart';
import '../../core/component/router/app_router.dart';
import '../extension/extension.dart';
import '../feature/image_action/part.dart';
import '../page/settings/cubit/settings_cubit.dart';
import '../theme/theme.dart';
import '../utils/utils.dart';
import 'enhancement/progress_indicator.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({
    super.key,
    required this.textHtml,
    this.renderMode = RenderMode.sliverList,
    this.padding = const EdgeInsets.only(left: 20, right: 20, bottom: 40),
    this.textStyle,
  });

  final String textHtml;
  final RenderMode renderMode;
  final EdgeInsets padding;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final publicationConfig = state.publication;
        final isImageVisible = publicationConfig.isImagesVisible;
        final fontSize =
            theme.textTheme.bodyLarge!.fontSize! * publicationConfig.fontScale;
        final isWebViewEnabled = publicationConfig.webViewEnabled;

        return HtmlWidget(
          textHtml,
          renderMode: renderMode,
          textStyle: textStyle,
          rebuildTriggers: [
            Theme.of(context).brightness,
            fontSize,
            isImageVisible,
            isWebViewEnabled,
          ],
          onErrorBuilder: (_, element, error) => Text('$element error: $error'),
          onLoadingBuilder: (ctx, el, prgrs) => const CircleIndicator.medium(),
          factoryBuilder: () => CustomFactory(context, textStyle: textStyle),
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
                'background-color':
                    theme.colorScheme.surfaceContainerHighest.toHex(),
                'font-weight': '500',
              };
            }

            final headerWeight = switch (element.localName) {
              'h1' || 'h2' => '600',
              'h3' || 'h4' => '500',
              'h5' || 'h6' => '400',
              _ => '',
            };
            if (headerWeight.isNotEmpty) {
              return {
                'font-family': 'Geologica',
                'font-weight': headerWeight,
              };
            }

            if (element.localName == 'li') {
              return {
                'margin-bottom': '6px',
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
                height: AppDimensions.imageHeight,
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
  CustomFactory(this.context, {this.textStyle});

  final BuildContext context;
  final TextStyle? textStyle;

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

    /// переопределяем цвета svg изображений в публикации -
    /// обычно это математические символы/формулы
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
        context.read<SettingsCubit>().state.publication.webViewEnabled;

    switch (element.localName) {
      case 'a':
        final op = BuildOp.v2(
          onParsed: (tree) {
            final href = attributes['href'];
            if (href == null) {
              return tree;
            }

            /// anchor links обрабатываются самой библиотекой
            if (href.startsWith('#')) {
              return tree;
            }

            /// проверяем необходимость открытия модалки
            /// для того чтобы показать полную ссылку на ресурс
            ///
            /// если текст не совпадает со ссылкой - показываем
            final isNeedPopup = tree.element.text != href;
            go() => getIt<AppRouter>().navigateOrLaunchUrl(Uri.parse(href));

            final widget = GestureDetector(
              child: tree.build(),
              onTap: () async {
                if (!isNeedPopup) {
                  return go();
                }

                getIt<Utils>().showAlert(
                  context: context,
                  compact: true,
                  title: Text(
                    tree.element.text,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  content: Text(href),
                  actionsBuilder: (context) => [
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(
                          ClipboardData(text: href),
                        );

                        getIt<Utils>().showSnack(
                          context: context,
                          content: const Text(
                            'Скопировано в буфер обмена',
                          ),
                        );
                      },
                      child: Text('Копировать в буфер'),
                    ),
                    TextButton(
                      onPressed: () {
                        go();
                        Navigator.of(context).pop();
                      },
                      child: Text('Перейти'),
                    ),
                  ],
                );
              },
            );

            final parent = tree.parent;
            return parent.sub()
              ..prepend(
                WidgetBit.inline(
                  parent,
                  WidgetPlaceholder(child: widget),
                ),
              );
          },
        );

        meta.register(op);
        break;
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
    return Stack(
      children: [
        ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              child: Text(
                text,
                style: textStyle?.copyWith(
                  fontVariations: [FontVariation('wght', 500)],
                ),
              ),
            ),
          ),
        ),

        /// TODO: копирование в буфер обмена
        // Positioned(
        //   top: 0,
        //   right: 0,
        //   child: IconButton(
        //     onPressed: () {
        //       Clipboard.setData(ClipboardData(text: text));

        //       getIt<Utils>().showSnack(
        //         context: context,
        //         content: const Text('Скопировано в буфер обмена'),
        //       );
        //     },
        //     icon: Icon(Icons.copy),
        //   ),
        // ),
      ],
    );
  }
}
