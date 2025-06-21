import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/darcula.dart';
import 'package:flutter_highlight/themes/github_gist.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_svg/fwfh_svg.dart';
import 'package:fwfh_webview/fwfh_webview.dart';
import 'package:path/path.dart' as p;

import '../../bloc/settings/settings_cubit.dart';
import '../../core/component/router/app_router.dart';
import '../../di/di.dart';
import '../../feature/image_action/image_action.dart';
import '../extension/extension.dart';
import '../theme/theme.dart';
import 'enhancement/progress_indicator.dart';

class HtmlView extends StatelessWidget {
  const HtmlView({
    super.key,
    required this.textHtml,
    this.renderMode = RenderMode.sliverList,
    this.padding = const EdgeInsets.only(left: 20, right: 20, bottom: 40),
    this.textStyle = const TextStyle(),
  });

  final String textHtml;
  final RenderMode renderMode;
  final EdgeInsets padding;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final publicationConfig = state.publication;
        final isImageVisible = publicationConfig.isImagesVisible;
        final fontScale = publicationConfig.fontScale;
        final fontSize =
            (theme.textTheme.bodyMedium?.fontSize ?? 14) * fontScale;
        final isWebViewEnabled = publicationConfig.webViewEnabled;

        return HtmlWidget(
          textHtml,
          renderMode: renderMode,
          textStyle: textStyle,
          rebuildTriggers: [
            theme.brightness,
            fontSize,
            isImageVisible,
            isWebViewEnabled,
          ],
          onErrorBuilder: (_, element, error) => Text('$element error: $error'),
          onLoadingBuilder: (ctx, el, prgrs) => const CircleIndicator.medium(),
          factoryBuilder:
              () => CustomFactory(
                context,
                textStyle: textStyle,
                fontScale: fontScale,
              ),
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
                'background-color': theme.colors.cardHighlight.toHex,
                'font-weight': '500',
              };
            }

            final headerWeight = switch (element.localName) {
              'h1' || 'h2' || 'h3' || 'h4' || 'h5' || 'h6' => '700',
              _ => '',
            };
            if (headerWeight.isNotEmpty) {
              return {'font-family': 'Geologica', 'font-weight': headerWeight};
            }

            if (element.localName == 'li') {
              return {'margin-bottom': '6px'};
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

              final imgSrc =
                  element.attributes['data-src'] ??
                  element.attributes['src'] ??
                  '';
              if (imgSrc.isEmpty) {
                return null;
              }

              String imgExt = p.extension(imgSrc);

              /// svg обрабатывется с помощью `SvgFactory`
              if (imgExt == '.svg') {
                return null;
              }

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
                widget = Tooltip(message: tooltip, child: widget);
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
  CustomFactory(this.context, {required this.textStyle, this.fontScale = 1.0});

  final BuildContext context;
  final TextStyle textStyle;
  final double fontScale;

  @override
  bool get webView => true;

  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;

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

    return widget;
  }

  @override
  void parse(BuildTree meta) {
    final element = meta.element;
    final attributes = element.attributes;
    final finalTextStyle = textStyle.copyWith(
      fontSize: (textStyle.fontSize ?? 14) * fontScale,
    );

    switch (element.localName) {
      case 'a':
        final op = CustomBuildOp.buildLinkOp(context, attributes);

        meta.register(op);
        break;
      case 'div':
        if (element.className.contains('tm-iframe_temp')) {
          final op = CustomBuildOp.buildWebViewOp(
            context,
            this,
            attributes,
            banFrameSources: ['video.yandex.ru/iframe'],
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

        final op = CustomBuildOp.buildCodeOp(
          context,
          attributes,
          text: element.text,
          textStyle: finalTextStyle,
        );

        meta.register(op);
        break;
    }

    return super.parse(meta);
  }
}

abstract class CustomBuildOp {
  static BuildOp buildLinkOp(
    BuildContext context,
    Map<Object, String> attributes,
  ) {
    return BuildOp.v2(
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
        Future<void> go() =>
            getIt<AppRouter>().navigateOrLaunchUrl(Uri.parse(href));

        final widget = GestureDetector(
          child: tree.build(),
          onTap: () async {
            if (!isNeedPopup) {
              return go();
            }

            context.showAlert(
              compact: true,
              title: Text(
                tree.element.text,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              content: Text(href),
              actionsBuilder:
                  (context) => [
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: href));

                        context.showSnack(
                          content: const Text('Скопировано в буфер обмена'),
                        );
                      },
                      child: const Text('Копировать в буфер'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        go();
                      },
                      child: const Text('Перейти'),
                    ),
                  ],
            );
          },
        );

        final parent = tree.parent;
        return parent.sub()
          ..prepend(WidgetBit.inline(parent, WidgetPlaceholder(child: widget)));
      },
    );
  }

  static BuildOp buildWebViewOp(
    BuildContext context,
    WebViewFactory factory,
    Map<Object, String> attributes, {

    /// список кривых iframe-источников
    List<String> banFrameSources = const [],
  }) {
    final isWebViewEnabled =
        context.read<SettingsCubit>().state.publication.webViewEnabled;

    return BuildOp(
      onRenderBlock: (meta, widgets) {
        String src = attributes['data-src'] ?? attributes['src'] ?? '';
        final isBanned = banFrameSources.any(
          (element) => src.contains(element),
        );
        final attrs = meta.element.attributes;
        final sandboxAttrs = attrs['sanbox'] ?? attrs['sandbox'];
        final widget =
            isWebViewEnabled && !isBanned
                ? factory.buildWebView(
                  meta,
                  src,
                  height: tryParseDoubleFromMap(attrs, 'height'),
                  width: tryParseDoubleFromMap(attrs, 'width'),
                  sandbox: sandboxAttrs?.split(RegExp(r'\s+')),
                )
                : factory.buildWebViewLinkOnly(meta, src);

        return widget ?? widgets;
      },
    );
  }

  static BuildOp buildCodeOp(
    BuildContext context,
    LinkedHashMap<Object, String> attributes, {
    required String text,
    TextStyle? textStyle,
  }) {
    final String? lang = attributes['class'];
    final codeTextStyle = textStyle?.copyWith(
      fontVariations: [const FontVariation.weight(300)],
    );
    final padding = const EdgeInsets.all(12);

    final codeTheme = switch (context.theme.brightness) {
      Brightness.dark => darculaTheme,
      Brightness.light => githubGistTheme,
    };

    final bgColor =
        codeTheme['root']?.backgroundColor ??
        context.theme.colors.cardHighlight;

    return BuildOp(
      onRenderBlock: (tree, placeholder) {
        if (lang != null) {
          Widget child = HighlightView(
            text,
            language: lang,
            tabSize: 4,
            textStyle: codeTextStyle,
            theme: codeTheme,
            padding: padding,
          );

          if (text.length > 200) {
            child = HighlightBackgroundEnvironment(child: child);
          }

          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: child,
          );
        }

        return Stack(
          children: [
            ColoredBox(
              color: bgColor,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.all(12),
                  child: Text(text, style: codeTextStyle),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
