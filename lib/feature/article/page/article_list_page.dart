import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/widget/article_list_sliver.dart';
import '../../../common/widget/enhancement/card.dart';
import '../../../common/widget/enhancement/responsive_visibility.dart';
import '../../../component/di/dependencies.dart';
import '../../../component/theme/constants.dart';
import '../../../component/theme/responsive.dart';
import '../../../config/constants.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../enhancement/scroll/cubit/scroll_cubit.dart';
import '../../enhancement/scroll/widget/floating_scroll_to_top_button.dart';
import '../../search/cubit/search_cubit.dart';
import '../../search/repository/search_repository.dart';
import '../../settings/cubit/settings_cubit.dart';
import '../../settings/repository/language_repository.dart';
import '../cubit/article_list_cubit.dart';
import '../model/article_type.dart';
import '../model/flow_enum.dart';
import '../repository/article_repository.dart';
import '../widget/article_list/article_list_appbar.dart';
import '../widget/most_reading_widget.dart';

@RoutePage(name: ArticleListPage.routeName)
class ArticleListPage extends StatelessWidget {
  const ArticleListPage({super.key, @PathParam() required this.flow});

  final String flow;

  static const String name = 'Статьи';
  static const String routePath = 'flows/:flow';
  static const String routeName = 'ArticleListRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      key: ValueKey('articles-$flow-flow'),
      providers: [
        BlocProvider(
          create: (_) => ArticleListCubit(
            repository: getIt.get<ArticleRepository>(),
            languageRepository: getIt.get<LanguageRepository>(),
            flow: FlowEnum.fromString(flow),
          ),
        ),
        BlocProvider(
          create: (_) => SearchCubit(
            repository: getIt.get<SearchRepository>(),
            langRepository: getIt.get<LanguageRepository>(),
          ),
        ),
        BlocProvider(
          create: (c) => ScrollCubit(),
        ),
      ],
      child: const ArticleListView(),
    );
  }
}

class ArticleListView extends StatelessWidget {
  const ArticleListView({
    super.key,
    this.type = ArticleType.article,
  });

  final ArticleType type;

  @override
  Widget build(BuildContext context) {
    final articlesCubit = context.read<ArticleListCubit>();
    final scrollCubit = context.read<ScrollCubit>();
    final scrollController = scrollCubit.state.controller;

    final sidebarHeight =
        Device.getHeight(context) - sortToolbarHeight - fToolBarHeight;

    return MultiBlocListener(
      listeners: [
        /// Если пользователь вошел, надо переполучить статьи
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.status.isLoading && c.isAuthorized,
          listener: (context, state) {
            articlesCubit.refetch();
          },
        ),

        /// Если пользователь вышел
        ///
        /// к тому же он находится в потоке "Моя лента", то отправляем его
        /// на поток "Все", виджет сам стриггерит получение статей
        ///
        /// иначе переполучаем статьи напрямую
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.status.isLoading && c.isUnauthorized,
          listener: (context, state) {
            if (articlesCubit.state.flow == FlowEnum.feed) {
              return articlesCubit.changeFlow(FlowEnum.all);
            }

            articlesCubit.refetch();
          },
        ),

        /// Смена языков
        BlocListener<SettingsCubit, SettingsState>(
          listenWhen: (previous, current) =>
              previous.langUI != current.langUI ||
              previous.langArticles != current.langArticles,
          listener: (_, __) => scrollCubit.animateToTop(),
        ),

        /// Когда скролл достиг предела, получаем следующую страницу
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (p, c) => c.isBottomEdge,
          listener: (c, state) => articlesCubit.fetch(),
        ),
      ],
      child: Scaffold(
        floatingActionButton: const FloatingScrollToTopButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: SafeArea(
          child: Scrollbar(
            controller: scrollController,
            child: CustomScrollView(
              cacheExtent: 1000,
              controller: scrollController,
              slivers: [
                ArticleListAppBar(type: type),
                ResponsiveVisibilitySliver(
                  hiddenConditions: [
                    Condition.largerThan(name: ScreenType.mobile, value: false)
                  ],
                  sliver: const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: kScreenHPadding + kCardMargin,
                        vertical: kCardBetweenPadding / 2,
                      ),
                      child: MostReadingWidget.button(),
                    ),
                  ),
                ),
                SliverCrossAxisGroup(
                  slivers: [
                    const ArticleListSliver(),
                    ResponsiveVisibilitySliver(
                      visible: false,
                      visibleConditions: [
                        Condition.largerThan(
                          name: ScreenType.mobile,
                          value: true,
                        )
                      ],
                      replacementSliver: const SliverConstrainedCrossAxis(
                        maxExtent: 0,
                        sliver: SliverToBoxAdapter(),
                      ),
                      sliver: SliverConstrainedCrossAxis(
                        maxExtent: ResponsiveValue<double>(
                          context,
                          defaultValue: 300,
                          conditionalValues: [
                            Condition.smallerThan(
                              name: ScreenType.desktop,
                              value: Device.getWidth(context) / 3,
                            ),
                          ],
                        ).value!,
                        sliver: SliverAppBar(
                          backgroundColor: Colors.transparent,
                          clipBehavior: Clip.none,
                          toolbarHeight: sidebarHeight,
                          expandedHeight: sidebarHeight,
                          floating: true,
                          pinned: true,
                          flexibleSpace: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: kScreenHPadding,
                              vertical: kScreenHPadding,
                            ),
                            child: _SideWidgetList(
                              widgets: [
                                _SideWidget(
                                  title: 'Читают сейчас',
                                  child: MostReadingWidget(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SideWidgetList extends StatefulWidget {
  const _SideWidgetList({required this.widgets});

  final List<_SideWidget> widgets;

  @override
  State<_SideWidgetList> createState() => _SideWidgetListState();
}

class _SideWidgetListState extends State<_SideWidgetList> {
  int showIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.widgets.length > 1;
    final widgetHeight = Device.getHeight(context) / 2;

    return Wrap(
      runSpacing: 12,
      children: widget.widgets.mapIndexed((index, sideWidget) {
        final isActiveWidget = showIndex == index;

        return FlabrCard(
          margin: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                enabled: isEnabled,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: kCardPadding,
                ),
                title: Text(
                  sideWidget.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                trailing: !isEnabled
                    ? null
                    : isActiveWidget
                        ? const Icon(Icons.keyboard_arrow_up_rounded)
                        : const Icon(Icons.keyboard_arrow_down_rounded),
                onTap: () => setState(() {
                  showIndex = index;
                }),
              ),
              if (isActiveWidget) ...[
                const Divider(),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: widgetHeight),
                  child: sideWidget.child,
                )
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SideWidget {
  const _SideWidget({required this.title, required this.child});

  final String title;
  final Widget child;
}
