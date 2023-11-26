import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/theme.dart';
import '../../../../config/constants.dart';
import '../../../auth/widget/profile_icon_button.dart';
import '../../../search/cubit/search_cubit.dart';
import '../../../search/page/search.dart';
import '../../../search/page/search_anywhere.dart';
import '../../cubit/article_list_cubit.dart';
import '../../model/article_type.dart';
import '../../model/flow_enum.dart';
import '../sort/articles_sort_widget.dart';
import 'flow_dropdown_menu.dart';

// const ArticlesSortWidget()

class ArticleListAppBar extends StatelessWidget {
  const ArticleListAppBar({super.key, required this.type});

  final ArticleType type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleListCubit, ArticleListState>(
      buildWhen: (previous, current) => previous.flow != current.flow,
      builder: (context, state) {
        return _AppBar(
          type: type,
          isFilterable: state.flow != FlowEnum.feed,
        );
      },
    );
  }
}

class _AppBar extends StatefulWidget {
  const _AppBar({
    required this.type,
    this.isFilterable = false,
  });

  final ArticleType type;
  final bool isFilterable;

  @override
  State<_AppBar> createState() => _AppBarState();
}

class _AppBarState extends State<_AppBar> {
  late double expandedHeight;
  bool isFilterShown = false;

  @override
  void initState() {
    expandedHeight = calcExpandedHeight();

    super.initState();
  }

  double calcExpandedHeight() {
    return fToolBarHeight +
        (widget.isFilterable && isFilterShown ? sortToolbarHeight : 0);
  }

  void onFilterPress() {
    setState(() {
      isFilterShown = !isFilterShown;
      expandedHeight = calcExpandedHeight();
    });
  }

  @override
  void didUpdateWidget(covariant _AppBar oldWidget) {
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
      title: FlowDropdownMenu(type: widget.type),
      flexibleSpace: FlexibleSpaceBar(
        expandedTitleScale: 1,
        background: widget.isFilterable && isFilterShown
            ? const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    kScreenHPadding,
                    0,
                    kScreenHPadding,
                    kScreenHPadding,
                  ),
                  child: ArticlesSortWidget(),
                ),
              )
            : null,
      ),
      actions: [
        if (widget.isFilterable)
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            padding: EdgeInsets.zero,
            onPressed: onFilterPress,
          ),
        if (widget.type == ArticleType.article)
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () async {
              final cubit = BlocProvider.of<SearchCubit>(context);

              await showFlabrSearch(
                context: context,
                delegate: SearchAnywhereDelegate(
                  cubit: cubit,
                ),
              );

              cubit.reset();
            },
          ),
        const Padding(
          padding: EdgeInsets.only(right: 20),
          child: MyProfileIconButton(),
        ),
      ],
    );
  }
}
