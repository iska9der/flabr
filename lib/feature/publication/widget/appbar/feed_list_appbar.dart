import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/theme.dart';
import '../../../../config/constants.dart';
import '../../cubit/feed_publication_list_cubit.dart';
import '../../cubit/publication_list_cubit.dart';
import '../sort/feed_sort_widget.dart';

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
                  child: BlocBuilder<FeedPublicationListCubit,
                      FeedPublicationListState>(
                    builder: (context, state) {
                      return FeedSortWidget(
                        isLoading:
                            state.status == PublicationListStatus.loading,
                        currentScore: state.score,
                        onScoreChange: (option) => context
                            .read<FeedPublicationListCubit>()
                            .changeFilterScore(option),
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
