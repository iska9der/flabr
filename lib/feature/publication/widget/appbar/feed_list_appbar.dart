import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/theme.dart';
import '../../../../config/constants.dart';
import '../../cubit/flow_publication_list_cubit.dart';
import '../../cubit/publication_list_cubit.dart';
import '../../model/sort/sort_enum.dart';
import '../sort/publication_sort_widget.dart';

class FeedListAppBar extends StatefulWidget {
  const FeedListAppBar({super.key});

  @override
  State<FeedListAppBar> createState() => _AppBarState();
}

class _AppBarState extends State<FeedListAppBar> {
  late double expandedHeight;
  bool isFilterShown = false;

  @override
  void initState() {
    expandedHeight = calcExpandedHeight();

    super.initState();
  }

  double calcExpandedHeight() {
    return fToolBarHeight + (isFilterShown ? fSortToolbarHeight : 0);
  }

  void onFilterPress() {
    setState(() {
      isFilterShown = !isFilterShown;
      expandedHeight = calcExpandedHeight();
    });
  }

  @override
  void didUpdateWidget(covariant FeedListAppBar oldWidget) {
    isFilterShown = false;
    expandedHeight = calcExpandedHeight();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      floating: true,
      snap: true,
      toolbarHeight: fToolBarHeight,
      expandedHeight: expandedHeight,
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        background: isFilterShown
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    kScreenHPadding,
                    0,
                    kScreenHPadding,
                    kScreenHPadding,
                  ),
                  child: BlocBuilder<FlowPublicationListCubit,
                      FlowPublicationListState>(
                    builder: (context, state) {
                      return PublicationSortWidget(
                        isLoading:
                            state.status == PublicationListStatus.loading,
                        sortValue: state.sort,
                        sortChange: (sort) => context
                            .read<FlowPublicationListCubit>()
                            .changeSort(sort),
                        optionValue: state.sort == SortEnum.byBest
                            ? state.period
                            : state.score,
                        optionChange: (option) => context
                            .read<FlowPublicationListCubit>()
                            .changeSortOption(
                              state.sort,
                              option,
                            ),
                      );
                    },
                  ),
                ),
              )
            : null,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          padding: EdgeInsets.zero,
          onPressed: onFilterPress,
        ),
      ],
    );
  }
}
