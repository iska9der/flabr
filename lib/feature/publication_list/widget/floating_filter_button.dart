import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/theme/theme.dart';
import '../../../presentation/widget/navigation/navigation.dart';
import '../cubit/publication_list_cubit.dart';

class FloatingFilterButton<
  ListCubit extends PublicationListCubit<ListState>,
  ListState extends PublicationListState
>
    extends StatelessWidget {
  const FloatingFilterButton({
    super.key,
    this.bloc,
    required this.filter,
  });

  final ListCubit? bloc;
  final Widget filter;

  @override
  Widget build(BuildContext context) {
    final isVisible = context.select<NavigationCubit, bool>(
      (cubit) => cubit.state.isNavigationVisible,
    );

    return AnimatedOpacity(
      duration: AppStyles.hideDuration,
      opacity: isVisible ? 1 : 0,
      child: IgnorePointer(
        ignoring: !isVisible,
        child: FloatingActionButton(
          heroTag: null,
          mini: true,
          onPressed: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            useRootNavigator: true,
            constraints: const BoxConstraints(minWidth: 600),
            builder: (_) => Padding(
              padding: AppInsets.filterSheetPadding,
              child: BlocProvider.value(
                value: context.read<ListCubit>(),
                child: filter,
              ),
            ),
          ),
          child: const Icon(Icons.filter_list_rounded),
        ),
      ),
    );
  }
}
