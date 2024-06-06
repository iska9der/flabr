import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/component/di/injector.dart';
import '../../../../feature/auth/cubit/auth_cubit.dart';
import '../../../../feature/auth/widget/dialog.dart';
import '../../../../feature/publication_list/part.dart';
import '../../../../theme/part.dart';
import '../../../../utils/utils.dart';
import '../../widget/list_appbar.dart';
import '../cubit/feed_publication_list_cubit.dart';
import 'feed_filter_widget.dart';

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
          return FeedFilterWidget(
            isLoading: state.status == PublicationListStatus.loading,
            currentScore: state.filter.score,
            currentTypes: state.filter.types,
            onSubmit: (newFilter) {
              if (context.read<AuthCubit>().state.isAuthorized) {
                context.read<FeedPublicationListCubit>().applyFilter(newFilter);
                return;
              }

              getIt.get<Utils>().showSnack(
                    context: context,
                    content: const Text('Войдите, чтобы настроить фильтры'),
                    action: SnackBarAction(
                      label: 'Войти',
                      onPressed: () => showLoginDialog(context),
                    ),
                  );
            },
          );
        },
      ),
    );
  }
}
