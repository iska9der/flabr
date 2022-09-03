import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/model/extension/state_status_x.dart';
import '../../../common/model/render_type.dart';
import '../../../common/utils/utils.dart';
import '../../../component/di/dependencies.dart';
import '../../../config/constants.dart';
import '../../../widget/progress_indicator.dart';
import '../../article/widget/article_card_widget.dart';
import '../../hub/widget/hub_card_widget.dart';
import '../../scroll/cubit/scroll_cubit.dart';
import '../../scroll/widget/floating_scroll_to_top_button.dart';
import '../../user/widget/user_card_widget.dart';
import '../cubit/search_cubit.dart';
import 'search_order.dart';
import 'search_target.dart';

class FlabrSearchDelegate extends SearchDelegate {
  FlabrSearchDelegate({required this.cubit});

  final SearchCubit cubit;

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
    return Stack(children: [
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
        child: _OrderOptions(cubit: cubit, delegate: this),
      ),
    ]);
  }

  @override
  Widget buildResults(BuildContext context) {
    cubit.changeQuery(query);

    return BlocProvider(
      create: (c) => ScrollCubit()..setUpEdgeListeners(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<SearchCubit, SearchState>(
            bloc: cubit,
            listenWhen: (p, c) => p.page != 1 && c.status.isFailure,
            listener: (c, state) {
              getIt.get<Utils>().showNotification(
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
        child: BlocBuilder<SearchCubit, SearchState>(
          bloc: cubit,
          builder: (context, state) {
            final scrollCtrl = context.read<ScrollCubit>().state.controller;

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
              return Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(kScreenHPadding),
                child: const Text('Поиск не дал результатов'),
              );
            }

            return Stack(
              children: [
                Scrollbar(
                  controller: scrollCtrl,
                  child: SingleChildScrollView(
                    controller: scrollCtrl,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _TargetOptions(cubit: cubit, delegate: this),
                        _OrderOptions(cubit: cubit, delegate: this),
                        ListView.separated(
                          cacheExtent: 5000,
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.symmetric(
                            horizontal: kScreenHPadding,
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: kCardBetweenPadding,
                          ),
                          itemCount:
                              models.length + (state.status.isLoading ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < models.length) {
                              var model = models[index];

                              switch (state.target) {
                                case SearchTarget.posts:
                                  return ArticleCardWidget(
                                    article: model,
                                    renderType: RenderType.html,
                                  );
                                case SearchTarget.hubs:
                                  return HubCardWidget(
                                    model: model,
                                    renderType: RenderType.html,
                                  );
                                case SearchTarget.companies:
                                  return const Center(
                                      child: Text('Не реализовано'));
                                case SearchTarget.users:
                                  return UserCardWidget(model: model);
                                case SearchTarget.comments:
                                  return const Center(
                                      child: Text('Не реализовано'));
                              }
                            }

                            Timer(
                              const Duration(milliseconds: 30),
                              () =>
                                  context.read<ScrollCubit>().animateToBottom(),
                            );

                            return const SizedBox(
                              height: 60,
                              child: CircleIndicator.medium(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingScrollToTopButton(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _TargetOptions extends StatelessWidget {
  const _TargetOptions({
    Key? key,
    required this.cubit,
    required this.delegate,
  }) : super(key: key);

  final SearchCubit cubit;
  final SearchDelegate delegate;

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
    Key? key,
    required this.cubit,
    required this.delegate,
  }) : super(key: key);

  final SearchCubit cubit;
  final SearchDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      bloc: cubit,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: kScreenHPadding),
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
