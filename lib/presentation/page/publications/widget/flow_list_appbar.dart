import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/filter/sort_enum.dart';
import '../../../feature/publication_list/part.dart';
import '../../../theme/part.dart';
import '../../../widget/publication_filter_widget.dart';
import '../cubit/flow_publication_list_cubit.dart';
import 'flow_dropdown_menu.dart';
import 'list_appbar.dart';

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
          return PublicationFilterWidget(
            isLoading: state.status == PublicationListStatus.loading,
            sort: state.sort,
            onSortChange: context.read<FlowPublicationListCubit>().changeSortBy,
            filterOption: switch (state.sort) {
              Sort.byBest => state.period,
              Sort.byNew => state.score,
            },
            onOptionChange: (option) => context
                .read<FlowPublicationListCubit>()
                .changeSortByOption(state.sort, option),
          );
        },
      ),
      title: const FlowDropdownMenu(),
    );
  }
}
