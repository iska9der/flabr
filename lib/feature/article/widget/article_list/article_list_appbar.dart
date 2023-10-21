import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../component/theme/constants.dart';
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

class ArticleListAppBar extends StatelessWidget {
  const ArticleListAppBar({super.key, required this.type});

  final ArticleType type;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticleListCubit, ArticleListState>(
      buildWhen: (previous, current) => previous.flow != current.flow,
      builder: (context, state) {
        bool isShowExpanded = state.flow != FlowEnum.feed;
        double expHeight =
            fToolBarHeight + (isShowExpanded ? sortToolbarHeight : 0);

        return SliverAppBar(
          automaticallyImplyLeading: false,
          floating: true,
          snap: true,
          title: FlowDropdownMenu(type: type),
          expandedHeight: expHeight,
          actions: [
            if (type == ArticleType.article)
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
          flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1,
            background: isShowExpanded
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ArticlesSortWidget(),
                  )
                : null,
          ),
        );
      },
    );
  }
}
