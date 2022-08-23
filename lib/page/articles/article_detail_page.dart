import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../common/utils/utils.dart';
import '../../common/widget/network_image_widget.dart';
import '../../common/widget/progress_indicator.dart';
import '../../component/di/dependencies.dart';
import '../../config/constants.dart';
import '../../feature/article/cubit/article_cubit.dart';
import '../../feature/article/service/articles_service.dart';
import '../../feature/article/widget/article_card_widget.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({
    Key? key,
    @PathParam() required this.id,
  }) : super(key: key);

  final String id;

  static const String routePath = ':id';
  static const String routeName = 'ArticleDetailRoute';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => ArticleCubit(
        id,
        service: getIt.get<ArticlesService>(),
      )..fetch(),
      child: const ArticleDetailPageView(),
    );
  }
}

class ArticleDetailPageView extends StatelessWidget {
  const ArticleDetailPageView({Key? key}) : super(key: key);

  static const hPadding = 12.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<ArticleCubit, ArticleState>(
          builder: (context, state) {
            if (state.status == ArticleStatus.loading) {
              return const CircleIndicator();
            }
            if (state.status == ArticleStatus.failure) {
              return Center(child: Text(state.error));
            }

            final article = state.article;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  toolbarHeight: 40,
                  titleSpacing: 0,
                  title: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero,
                    expandedTitleScale: 1,
                    title: Row(
                      children: [
                        const AutoLeadingButton(),
                        Expanded(
                          child: Text(
                            article.titleHtml,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).appBarTheme.titleTextStyle!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: hPadding,
                        vertical: 16.0,
                      ),
                      child: ArticleTopRow(article),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: hPadding,
                        right: hPadding,
                        bottom: hPadding,
                      ),
                      child: SelectableText(
                        article.titleHtml,
                        textAlign: TextAlign.left,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    Html(
                      data: article.textHtml,
                      onLinkTap: (url, context, attributes, element) async {
                        if (url != null) {
                          await getIt.get<Utils>().launcher.launchUrl(url);
                        }
                      },
                      style: {
                        'blockquote': Style(
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: hPadding,
                            vertical: 6,
                          ),
                          fontStyle: FontStyle.italic,
                          fontSize: const FontSize(12),
                        ),
                        'pre': Style(
                          fontStyle: FontStyle.normal,
                          fontSize: const FontSize(12),
                        ),
                        'figure': Style(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                        ),
                        'img': Style(
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.all(0),
                        ),
                        'a': Style(textDecoration: TextDecoration.none),
                      },
                      customRenders: {
                        figureMatcher(): CustomRender.widget(
                          widget: (context, children) {
                            for (final tag in context.tree.children) {
                              if (tag.name == 'img') {
                                String imgUrl =
                                    tag.element!.attributes['data-src'] ??
                                        tag.element!.attributes['src'] ??
                                        '';

                                if (imgUrl.isNotEmpty) {
                                  return Align(
                                    child: NetworkImageWidget(url: imgUrl),
                                  );
                                }
                              }
                            }

                            return Row();
                          },
                        ),
                        preMatcher(): CustomRender.widget(
                          widget: (ctx, children) {
                            final ScrollController controller =
                                ScrollController();

                            List<InlineSpan> spans = children();

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
                                  child: SelectableText.rich(
                                    TextSpan(
                                      children: spans,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        iFrameVideoMatcher(): CustomRender.widget(
                          widget: (context, children) {
                            String dataSrc =
                                context.tree.attributes['data-src'] ?? '';

                            /// если нет ссылки на iframe
                            if (dataSrc.isEmpty) {
                              return Wrap();
                            }

                            String initialUri = Uri.dataFromString(
                              '<html><meta name="viewport" content="width=device-width,initial-scale=1"><body style="margin:0;padding:0;"><iframe style="border:none;" width="100%" height="100%" src="$dataSrc" controls allow="fullscreen"></iframe></body></html>',
                              mimeType: 'text/html',
                            ).toString();

                            return SizedBox(
                              height: postImageHeight + 5,
                              child: WebView(
                                initialUrl: initialUri,
                                javascriptMode: JavascriptMode.unrestricted,
                              ),
                            );
                          },
                        ),
                        imgMatcher(): CustomRender.widget(
                          widget: (context, children) {
                            String? fullImg =
                                context.tree.element?.attributes['data-src'];

                            if (fullImg == null || fullImg.isEmpty) {
                              fullImg =
                                  context.tree.element?.attributes['src'] ?? '';
                            }

                            return Align(
                              child: NetworkImageWidget(url: fullImg),
                            );
                          },
                        ),
                      },
                    ),
                  ]),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  CustomRenderMatcher figureMatcher() =>
      (context) => context.tree.element?.localName == 'figure';

  CustomRenderMatcher preMatcher() => (context) =>
      context.tree.element?.localName == 'pre' &&
      context.tree.children.isNotEmpty;

  CustomRenderMatcher iFrameVideoMatcher() =>
      (context) => context.tree.element?.className == 'tm-iframe_temp';

  CustomRenderMatcher imgMatcher() =>
      (context) => context.tree.element?.localName == 'img';
}
