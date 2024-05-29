import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/theme.dart';
import '../../../../config/constants.dart';
import '../../cubit/flow_publication_list_cubit.dart';
import '../../cubit/publication_list_cubit.dart';
import '../../model/sort/sort_enum.dart';
import '../sort/publication_sort_widget.dart';
import 'flow_dropdown_menu.dart';

class FlowListAppBar extends StatefulWidget {
  const FlowListAppBar({super.key});

  @override
  State<FlowListAppBar> createState() => _AppBarState();
}

class _AppBarState extends State<FlowListAppBar> {
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
  void didUpdateWidget(covariant FlowListAppBar oldWidget) {
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
      title: const FlowDropdownMenu(),
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
                        sortBy: state.sort,
                        sortByChange: (option) => context
                            .read<FlowPublicationListCubit>()
                            .changeSortBy(option.value),
                        sortByDetail: state.sort == SortEnum.byBest
                            ? state.period
                            : state.score,
                        sortByDetailChange: (option) => context
                            .read<FlowPublicationListCubit>()
                            .changeSortByOption(state.sort, option.value),
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
