import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/publication/flow_publication_list_cubit.dart';
import '../../../../data/model/filter/filter.dart';
import '../../../../data/model/publication/publication.dart';
import '../../../../i18n/i18n.dart';
import '../../../extension/extension.dart';
import '../../../theme/theme.dart';
import '../../../widget/filter/common_filters_widget.dart';

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
    super.initState();

    selectedFlow = context.read<FlowPublicationListCubit>().state.flow;
  }

  @override
  Widget build(BuildContext context) {
    final translation = context.t;

    return BlocBuilder<FlowPublicationListCubit, FlowPublicationListState>(
      builder: (context, state) {
        final isEnabled = state.status != .loading;

        return Column(
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            Text(
              translation.publication.flow.title,
              style: context.theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _PublicationFlowChoices(
              isEnabled: isEnabled,
              selectedFlow: selectedFlow,
              onSelected: (flow) => setState(() => selectedFlow = flow),
            ),
            const SizedBox(height: 16),
            CommonFiltersWidget(
              isLoading: !isEnabled,
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _PublicationFlowChoices extends StatefulWidget {
  const _PublicationFlowChoices({
    required this.isEnabled,
    required this.selectedFlow,
    required this.onSelected,
  });

  final bool isEnabled;
  final PublicationFlow selectedFlow;
  final ValueChanged<PublicationFlow> onSelected;

  @override
  State<_PublicationFlowChoices> createState() =>
      _PublicationFlowChoicesState();
}

class _PublicationFlowChoicesState extends State<_PublicationFlowChoices> {
  late bool isExpanded;
  final visibleGroup = PublicationFlowGroup.values.first;

  @override
  void initState() {
    super.initState();

    isExpanded =
        widget.selectedFlow != PublicationFlow.all &&
        !visibleGroup.flows.contains(widget.selectedFlow);
  }

  void _toggleVisibility() => setState(() => isExpanded = !isExpanded);

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      children: [
        _buildChoiceChip(PublicationFlow.all),
        for (final group in PublicationFlowGroup.values)
          if (isExpanded || group == visibleGroup) ...[
            const SizedBox(height: 16),
            Text(
              group.label,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 40,
              child: ListView.separated(
                key: ValueKey(group),
                clipBehavior: .none,
                scrollDirection: .horizontal,
                itemCount: group.flows.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) =>
                    _buildChoiceChip(group.flows[index]),
              ),
            ),
          ],
        const SizedBox(height: 4),
        SizedBox(
          key: const ValueKey('publication-flow-expand'),
          width: double.infinity,
          height: 40,
          child: TextButton.icon(
            label: Text(
              isExpanded
                  ? context.t.publication.flow.collapse
                  : context.t.publication.flow.expand,
            ),
            icon: Icon(
              isExpanded ? AppIcons.chevronUp : AppIcons.chevronDown,
            ),
            iconAlignment: .end,
            onPressed: () => _toggleVisibility(),
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceChip(PublicationFlow flow) {
    return ChoiceChip(
      visualDensity: .compact,
      label: Text(flow.label),
      selected: flow == widget.selectedFlow,
      onSelected: widget.isEnabled ? (_) => widget.onSelected(flow) : null,
    );
  }
}
