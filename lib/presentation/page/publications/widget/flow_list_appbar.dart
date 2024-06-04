import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/sort/sort_enum.dart';
import '../../../theme/part.dart';
import '../cubit/flow_publication_list_cubit.dart';
import '../cubit/publication_list_cubit.dart';
import 'flow_dropdown_menu.dart';
import 'list_appbar.dart';
import 'publication_sort_widget.dart';

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
    return fToolBarHeight + (isFilterShown ? flowSortToolbarHeight : 0);
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
    return ListAppBar(
      filterHeight: flowSortToolbarHeight,
      filter: BlocBuilder<FlowPublicationListCubit, FlowPublicationListState>(
        builder: (context, state) {
          return PublicationSort(
            isLoading: state.status == PublicationListStatus.loading,
            sortBy: state.sort,
            sortByChange: (option) => context
                .read<FlowPublicationListCubit>()
                .changeSortBy(option.value),
            sortByDetail:
                state.sort == Sort.byBest ? state.period : state.score,
            sortByDetailChange: (option) => context
                .read<FlowPublicationListCubit>()
                .changeSortByOption(state.sort, option.value),
          );
        },
      ),
      title: const FlowDropdownMenu(),
    );
  }
}
