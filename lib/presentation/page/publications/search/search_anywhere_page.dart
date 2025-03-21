import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/component/di/di.dart';
import '../../../../data/model/render_type_enum.dart';
import '../../../../data/model/search/search_order_enum.dart';
import '../../../../data/model/search/search_target_enum.dart';
import '../../../../feature/scroll/scroll.dart';
import '../../../extension/extension.dart';
import '../../../utils/utils.dart';
import '../../../widget/enhancement/progress_indicator.dart';
import '../../services/company/widget/company_card_widget.dart';
import '../../services/hub/widget/hub_card_widget.dart';
import '../../services/user/widget/user_card_widget.dart';
import '../widget/card/card.dart';
import 'cubit/search_cubit.dart';

@RoutePage(name: SearchAnywherePage.routeName)
class SearchAnywherePage extends StatelessWidget {
  const SearchAnywherePage({super.key});

  static const String routePath = '/search';
  static const String routeName = 'SearchAnywhereRoute';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => SearchCubit(repository: getIt(), langRepository: getIt()),
        ),
        BlocProvider<ScrollCubit>(create: (_) => ScrollCubit()),
      ],
      child: const _SearchAnywhereView(),
    );
  }
}

class _SearchAnywhereView extends StatefulWidget {
  // ignore: unused_element
  const _SearchAnywhereView({super.key});

  @override
  State<_SearchAnywhereView> createState() => _SearchAnywhereViewState();
}

class _SearchAnywhereViewState extends State<_SearchAnywhereView> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _queryTextController = TextEditingController();

  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        systemOverlayStyle:
            colorScheme.brightness == Brightness.dark
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
        backgroundColor:
            colorScheme.brightness == Brightness.dark
                ? Colors.grey[900]
                : Colors.white,
        iconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
        titleTextStyle: theme.textTheme.titleLarge,
        toolbarTextStyle: theme.textTheme.bodyMedium,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: theme.inputDecorationTheme.hintStyle,
        border: InputBorder.none,
      ),
    );
  }

  void showResults(BuildContext context, query) {
    _focusNode.unfocus();
    context.read<SearchCubit>().changeQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = appBarTheme(context);
    _focusNode.requestFocus();
    final scrollCubit = context.read<ScrollCubit>();
    final scrollCtrl = scrollCubit.state.controller;

    return MultiBlocListener(
      listeners: [
        BlocListener<SearchCubit, SearchState>(
          listenWhen: (p, c) => p.page != 1 && c.status.isFailure,
          listener: (c, state) {
            getIt<Utils>().showSnack(
              context: context,
              content: Text(state.error),
            );
          },
        ),
        BlocListener<ScrollCubit, ScrollState>(
          listenWhen: (p, c) => c.isBottomEdge,
          listener: (c, state) => context.read<SearchCubit>().fetch(),
        ),
      ],
      child: Theme(
        data: theme,
        child: Scaffold(
          floatingActionButton: const FloatingScrollToTopButton(),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            title: TextField(
              controller: _queryTextController,
              focusNode: _focusNode,
              style: theme.textTheme.titleLarge,
              textInputAction: TextInputAction.search,
              onSubmitted: (String query) => showResults(context, query),
              decoration: const InputDecoration(hintText: 'Поиск'),
            ),
          ),
          body: Scrollbar(
            controller: scrollCtrl,
            child: CustomScrollView(
              controller: scrollCtrl,
              slivers: [
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    return SliverMainAxisGroup(
                      slivers: [
                        SliverToBoxAdapter(
                          child: _TargetOptions(
                            onSubmit:
                                (String query) => showResults(context, query),
                          ),
                        ),
                        if (state.target == SearchTarget.posts ||
                            state.target == SearchTarget.users)
                          SliverToBoxAdapter(
                            child: _OrderOptions(
                              onSubmit:
                                  (String query) => showResults(context, query),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state.isFirstFetch) {
                      if (state.status.isLoading) {
                        return const SliverFillRemaining(
                          child: CircleIndicator(),
                        );
                      }
                      if (state.status.isFailure) {
                        return SliverFillRemaining(
                          child: Align(child: Text(state.error)),
                        );
                      }
                    }

                    var models = state.listResponse.refs;

                    if (models.isEmpty) {
                      return const SliverFillRemaining(
                        child: Align(child: Text('Поиск не дал результатов')),
                      );
                    }

                    return SliverList.builder(
                      itemCount:
                          models.length + (state.status.isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index < models.length) {
                          var model = models[index];

                          return switch (state.target) {
                            SearchTarget.posts => CommonCardWidget(
                              publication: model,
                              renderType: RenderType.html,
                            ),
                            SearchTarget.hubs => HubCardWidget(
                              model: model,
                              renderType: RenderType.html,
                            ),
                            SearchTarget.companies => CompanyCardWidget(
                              model: model,
                              renderType: RenderType.html,
                            ),
                            SearchTarget.users => UserCardWidget(model: model),
                            SearchTarget.comments => const Center(
                              child: Text('Не реализовано'),
                            ),
                          };
                        }

                        Timer(
                          scrollCubit.duration,
                          () => scrollCubit.animateToBottom(),
                        );

                        return const SizedBox(
                          height: 60,
                          child: CircleIndicator.medium(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TargetOptions extends StatelessWidget {
  const _TargetOptions({required this.onSubmit});

  final Function(String query) onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children:
                SearchTarget.values
                    .map(
                      (target) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(target.label),
                          selected: state.target == target,
                          onSelected: (value) {
                            context.read<SearchCubit>().changeTarget(target);

                            if (state.query.isNotEmpty) {
                              onSubmit(state.query);
                            }
                          },
                        ),
                      ),
                    )
                    .toList(),
          ),
        );
      },
    );
  }
}

class _OrderOptions extends StatelessWidget {
  const _OrderOptions({required this.onSubmit});

  final Function(String query) onSubmit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FittedBox(
            child: Row(
              children:
                  SearchOrder.values
                      .map(
                        (order) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ChoiceChip(
                            label: Text(order.label),
                            selected: state.order == order,
                            onSelected: (value) {
                              context.read<SearchCubit>().changeSort(order);

                              if (state.query.isNotEmpty) {
                                onSubmit(state.query);
                              }
                            },
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
        );
      },
    );
  }
}
