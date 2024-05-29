import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/theme.dart';
import '../../../../config/constants.dart';
import '../../cubit/feed_publication_list_cubit.dart';
import '../../cubit/publication_list_cubit.dart';
import '../sort/feed_sort_widget.dart';
import 'list_appbar.dart';

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
    return fToolBarHeight + (isFilterShown ? feedSortToolbarHeight : 0);
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
    return ListAppBar(
      filterHeight: feedSortToolbarHeight,
      filter: BlocBuilder<FeedPublicationListCubit, FeedPublicationListState>(
        builder: (context, state) {
          return FeedSortWidget(
            isLoading: state.status == PublicationListStatus.loading,
            currentScore: state.score,
            onScoreChange: (option) => context
                .read<FeedPublicationListCubit>()
                .changeFilterScore(option),
            currentTypes: state.types,
            onTypesChange: (newTypes) => context
                .read<FeedPublicationListCubit>()
                .changeFilterTypes(newTypes),
          );
        },
      ),
    );
  }
}
