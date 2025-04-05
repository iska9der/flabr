import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/publication/flow_publication_list_cubit.dart';
import '../../../../data/model/filter/filter.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../feature/publication_list/publication_list.dart';
import '../../../widget/filter/common_filters_widget.dart';
import '../../../widget/filter/filter_chip_list.dart';

class PublicationFiltersWidget extends StatefulWidget {
  const PublicationFiltersWidget({super.key});

  @override
  State<PublicationFiltersWidget> createState() =>
      _PublicationFiltersWidgetState();
}

class _PublicationFiltersWidgetState extends State<PublicationFiltersWidget> {
  late PublicationFlow selectedFlow;

  @override
  void initState() {
    selectedFlow = context.read<FlowPublicationListCubit>().state.flow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<FlowPublicationListCubit, FlowPublicationListState>(
          builder: (context, state) {
            return FilterChipList(
              isEnabled: state.status != PublicationListStatus.loading,
              options:
                  PublicationFlow.values
                      .map((e) => FilterOption(label: e.label, value: e.name))
                      .toList(),
              isSelected: (option) => option.value == selectedFlow.name,
              onSelected: (isSelected, option) {
                final newFlow = PublicationFlow.fromString(option.value);

                setState(() {
                  selectedFlow = newFlow;
                });
              },
            );
          },
        ),
        const SizedBox(height: 24),
        BlocBuilder<FlowPublicationListCubit, FlowPublicationListState>(
          builder: (context, state) {
            return CommonFiltersWidget(
              isLoading: state.status == PublicationListStatus.loading,
              sort: state.filter.sort,
              filterOption: switch (state.filter.sort) {
                Sort.byBest => state.filter.period,
                Sort.byNew => state.filter.score,
              },
              onSubmit: (newFilter) {
                context.read<FlowPublicationListCubit>().applyFilter(
                  selectedFlow,
                  newFilter,
                );
              },
            );
          },
        ),
      ],
    );
  }
}
