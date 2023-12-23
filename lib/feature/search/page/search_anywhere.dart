import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/enum_status.dart';
import '../../../common/model/render_type.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widget/enhancement/progress_indicator.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../company/widget/company_card_widget.dart';
import '../../enhancement/scroll/scroll.dart';
import '../../hub/widget/hub_card_widget.dart';
import '../../publication/widget/card/common_card_widget.dart';
import '../../user/widget/user_card_widget.dart';
import '../cubit/search_cubit.dart';
import '../model/search_order.dart';
import '../model/search_target.dart';
import 'search.dart';

class SearchAnywhereDelegate extends FlabrSearchDelegate {
  SearchAnywhereDelegate({required this.cubit});

  final SearchCubit cubit;

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          appBarTheme: Theme.of(context).appBarTheme,
        );
  }

  @override
  String? get searchFieldLabel => 'Поиск';

  @override
  List<Widget>? buildActions(BuildContext context) => null;

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_rounded),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _TargetOptions(cubit: cubit, delegate: this),
        ),
        Positioned(
          top: 40,
          left: 0,
          right: 0,
          child: BlocBuilder<SearchCubit, SearchState>(
            bloc: cubit,
            builder: (context, state) {
              if (state.target == SearchTarget.posts ||
                  state.target == SearchTarget.users) {
                return _OrderOptions(cubit: cubit, delegate: this);
              }

              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    cubit.changeQuery(query);

    return BlocProvider<ScrollCubit>(
      create: (_) => ScrollCubit(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SearchCubit, SearchState>(
            bloc: cubit,
            listenWhen: (p, c) => p.page != 1 && c.status.isFailure,
            listener: (c, state) {
              getIt.get<Utils>().showSnack(
                    context: context,
                    content: Text(state.error),
                  );
            },
          ),
          BlocListener<ScrollCubit, ScrollState>(
            listenWhen: (p, c) => c.isBottomEdge,
            listener: (c, state) => cubit.fetch(),
          ),
        ],
        child: Scaffold(
          floatingActionButton: const FloatingScrollToTopButton(),
          body: BlocBuilder<SearchCubit, SearchState>(
            bloc: cubit,
            builder: (context, state) {
              final scrollCubit = context.read<ScrollCubit>();
              final scrollCtrl = scrollCubit.state.controller;

              if (state.isFirstFetch) {
                if (state.status.isLoading) {
                  return const CircleIndicator();
                }
                if (state.status.isFailure) {
                  return Center(child: Text(state.error));
                }
              }

              var models = state.listResponse.refs;

              if (models.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(kScreenHPadding),
                  child: Align(
                    child: Text('Поиск не дал результатов'),
                  ),
                );
              }

              return Scrollbar(
                controller: scrollCtrl,
                child: CustomScrollView(
                  controller: scrollCtrl,
                  slivers: [
                    SliverToBoxAdapter(
                      child: _TargetOptions(cubit: cubit, delegate: this),
                    ),
                    if (state.target == SearchTarget.posts ||
                        state.target == SearchTarget.users)
                      SliverToBoxAdapter(
                        child: _OrderOptions(cubit: cubit, delegate: this),
                      ),
                    SliverList.builder(
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
                            SearchTarget.users => UserCardWidget(
                                model: model,
                              ),
                            SearchTarget.comments => const Center(
                                child: Text('Не реализовано'),
                              )
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
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TargetOptions extends StatelessWidget {
  const _TargetOptions({
    required this.cubit,
    required this.delegate,
  });

  final SearchCubit cubit;
  final FlabrSearchDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      bloc: cubit,
      builder: (context, state) {
        return SizedBox(
          height: 40,
          child: ListView(
            clipBehavior: Clip.none,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: SearchTarget.values
                .map((target) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(target.label),
                        selected: state.target == target,
                        onSelected: (value) {
                          cubit.changeTarget(target);

                          if (state.query.isNotEmpty) {
                            delegate.showResults(context);
                          }
                        },
                      ),
                    ))
                .toList(),
          ),
        );
      },
    );
  }
}

class _OrderOptions extends StatelessWidget {
  const _OrderOptions({
    required this.cubit,
    required this.delegate,
  });

  final SearchCubit cubit;
  final FlabrSearchDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      bloc: cubit,
      builder: (context, state) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FittedBox(
            child: Row(
              children: SearchOrder.values
                  .map((order) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(order.label),
                          selected: state.order == order,
                          onSelected: (value) {
                            cubit.changeSort(order);

                            if (state.query.isNotEmpty) {
                              delegate.showResults(context);
                            }
                          },
                        ),
                      ))
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
