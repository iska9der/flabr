part of '../part.dart';

class FloatingFilterButton<ListCubit extends PublicationListCubit<ListState>,
    ListState extends PublicationListState> extends StatelessWidget {
  const FloatingFilterButton({
    super.key,
    required this.filter,
  });

  final Widget filter;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          constraints: const BoxConstraints(
            minWidth: 600,
          ),
          builder: (_) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
            child: BlocProvider.value(
              value: context.read<ListCubit>(),
              child: filter,
            ),
          ),
        );
      },
      child: const Icon(Icons.filter_list_rounded),
    );
  }
}
