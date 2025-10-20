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

import '../../../bloc/settings/settings_cubit.dart';
import '../../../core/component/router/app_router.dart';
import '../../../di/di.dart';
import '../../../feature/image_action/image_action.dart';
import '../../extension/extension.dart';
import '../../theme/theme.dart';
import '../enhancement/progress_indicator.dart';
import 'html_dimension_parser.dart';
import 'lazy_code_block.dart';
import 'lazy_webview_block.dart';

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
        final resultTextStyle = textStyle.copyWith(fontSize: fontSize);

        return HighlightBackgroundEnvironment(
          child: HtmlWidget(
            textHtml,
            renderMode: renderMode,
            textStyle: resultTextStyle,
            rebuildTriggers: [
              theme.brightness,
              fontSize,
              isImageVisible,
              isWebViewEnabled,
            ],
            onErrorBuilder: (_, element, error) =>
                Text('$element error: $error'),
            onLoadingBuilder: (ctx, el, prgrs) =>
                const CircleIndicator.medium(),
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
                  'background-color': theme.colors.cardHighlight.toHex,
                  'font-weight': '500',
                };
              }

              final headerWeight = switch (element.localName) {
                'h1' || 'h2' || 'h3' || 'h4' || 'h5' || 'h6' => '700',
                _ => '',
              };
              if (headerWeight.isNotEmpty) {
                return {
                  'font-family': 'Geologica',
                  'font-weight': headerWeight,
                };
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
                  return const SizedBox.shrink();
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
          ),
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

  ThemeData get theme => context.theme;

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
        theme.textTheme.bodyMedium!.color!,
        BlendMode.srcIn,
      ),
    );

    return widget;
  }

  @override
  void parse(BuildTree meta) {
    final element = meta.element;
    final attributes = element.attributes;

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
    /// TODO: перенести в customWidgetBuilder с использованием InlineCustomWidget
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
              actionsBuilder: (context) => [
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
    final isWebViewEnabled = context
        .read<SettingsCubit>()
        .state
        .publication
        .webViewEnabled;

    return BuildOp(
      onRenderBlock: (meta, widgets) {
        String src = attributes['data-src'] ?? attributes['src'] ?? '';
        final isBanned = banFrameSources.any((b) => src.contains(b));
        final canShow = isWebViewEnabled && !isBanned;

        // Если WebView отключен или источник забанен, показываем только ссылку
        if (!canShow) {
          return factory.buildWebViewLinkOnly(meta, src) ?? widgets;
        }

        // Извлекаем высоту с учетом CSS стилей и родительских элементов
        // Ширина всегда 100% (на всю ширину экрана)
        final element = meta.element;
        final width = Device.getWidth(context);
        final height = HtmlDimensionParser.extractHeight(element);
        final aspect = height != null ? width / height : 16 / 9;
        final sandboxAttrs =
            element.attributes['sandbox'] ?? element.attributes['sanbox'];

        // Используем LazyWebViewBlock для ленивой загрузки WebView
        final widget = LazyWebViewBlock(
          src: src,
          buildWebView: () {
            Widget? webView = factory.buildWebView(
              meta,
              src,
              height: height,
              sandbox: sandboxAttrs?.split(RegExp(r'\s+')),
            );

            if (webView != null) {
              /// Залочиваем аспект соотношения чтобы при выходе из полноэкрана
              /// (например, YouTube видео) высота WebView не расла бесконечно.
              /// AspectRatio поддерживает стабильное соотношение сторон.
              webView = AspectRatio(aspectRatio: aspect, child: webView);
            } else {
              webView = const SizedBox.shrink();
            }

            return webView;
          },
          placeholder: () =>
              factory.buildWebViewLinkOnly(meta, src) ??
              const SizedBox.shrink(),
        );

        return widget;
      },
    );
  }

  static BuildOp buildCodeOp(
    BuildContext context,
    LinkedHashMap<Object, String> attributes, {
    required String text,
  }) {
    final String? lang = attributes['class'];

    final fontSize =
        (context.theme.textTheme.bodySmall?.fontSize ?? 12) *
        context.read<SettingsCubit>().state.publication.fontScale;
    final codeTextStyle = context.theme.textTheme.bodyMedium!.copyWith(
      fontSize: fontSize,
      fontFamily: HighlightView.defaultFontFamily,
    );
    EdgeInsets padding = const EdgeInsets.all(12);

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
          final maxRows = 5;
          final splittedText = text.split('\n');
          final isLong = splittedText.length > maxRows;
          final previewText = isLong
              ? splittedText.getRange(0, 5).join('\n')
              : text;
          final tabSize = 4;

          padding = isLong ? padding.copyWith(bottom: 28) : padding;

          VoidCallback? onTap = switch (isLong) {
            false => null,
            true => () => context.buildModalRoute(
              rootNavigator: true,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: Device.getWidth(context),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HighlightView(
                    text,
                    language: lang,
                    tabSize: tabSize,
                    textStyle: codeTextStyle,
                    theme: codeTheme,
                    padding: padding,
                  ),
                ),
              ),
            ),
          };

          return ColoredBox(
            color: bgColor,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: Device.getWidth(context),
              ),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  LazyCodeBlock(
                    text: previewText,
                    language: lang,
                    textStyle: codeTextStyle,
                    maxRows: maxRows,
                    theme: codeTheme,
                    padding: padding,
                    onTap: onTap,
                  ),
                  if (isLong)
                    GestureDetector(
                      onTap: onTap,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 12, bottom: 6),
                        child: Text('Показать полностью...'),
                      ),
                    ),
                ],
              ),
            ),
          );
        }

        return ColoredBox(
          color: bgColor,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: Device.getWidth(context),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(12),
              child: Text(text, style: codeTextStyle),
            ),
          ),
        );
      },
    );
  }
}
