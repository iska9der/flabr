import 'package:flutter/material.dart';

import '../../../theme/part.dart';

class ListAppBar extends StatefulWidget {
  const ListAppBar({
    super.key,
    required this.filterHeight,
    required this.filter,
    this.title,
  });

  final double filterHeight;
  final Widget filter;
  final Widget? title;

  @override
  State<ListAppBar> createState() => _ListAppBarState();
}

class _ListAppBarState extends State<ListAppBar> {
  late double expandedHeight;
  bool isFilterShown = false;

  @override
  void initState() {
    expandedHeight = calcExpandedHeight();

    super.initState();
  }

  double calcExpandedHeight() {
    return fToolBarHeight + (isFilterShown ? widget.filterHeight : 0);
  }

  void onFilterPress() {
    setState(() {
      isFilterShown = !isFilterShown;
      expandedHeight = calcExpandedHeight();
    });
  }

  @override
  void didUpdateWidget(covariant ListAppBar oldWidget) {
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
      shadowColor: Theme.of(context).colorScheme.primary,
      scrolledUnderElevation: 4,
      title: widget.title,
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
                  child: widget.filter,
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
