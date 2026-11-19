import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../../bloc/auth/auth_cubit.dart';
import '../../../../../bloc/publication/feed_publication_list_cubit.dart';
import '../../../../../data/model/filter/filter.dart';
import '../../../../../i18n/i18n.dart';
import '../../../../widget/dialog/dialog.dart';
import '../../../../widget/filter/filter_chip_list.dart';
import '../../../../widget/filter/publication_criteria_widget.dart';
import '../../../../widget/filter/publication_filter_submit_button.dart';

class FeedFiltersWidget extends StatelessWidget {
  const FeedFiltersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BlocBuilder<FeedPublicationListCubit, FeedPublicationListState>(
          builder: (context, state) {
            return _FilterView(
              key: ValueKey(state.filter),
              isLoading: state.status == .loading,
              currentScore: state.filter.score,
              currentCriteria: state.filter.criteria,
              onSubmit: (newFilter) {
                if (context.read<AuthCubit>().state.isAuthorized) {
                  context.read<FeedPublicationListCubit>().applyFilter(
                    newFilter,
                  );
                  return;
                }

                showLoginSnackBar(context);
              },
            );
          },
        ),
      ],
    );
  }
}

class _FilterView extends StatefulWidget {
  const _FilterView({
    super.key,
    this.isLoading = false,
    required this.currentScore,
    required this.currentCriteria,
    required this.onSubmit,
  });

  final bool isLoading;

  final FilterOption currentScore;

  final PublicationCriteria currentCriteria;
  final void Function(FeedFilter filter) onSubmit;

  @override
  State<_FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<_FilterView> {
  late FilterOption scoreValue = widget.currentScore;
  late PublicationCriteria criteria = widget.currentCriteria;

  @override
  Widget build(BuildContext context) {
    const headerStyle = TextStyle(fontWeight: .w700);

    return Column(
      spacing: 6,
      crossAxisAlignment: .start,
      mainAxisSize: .min,
      children: [
        PublicationCriteriaWidget(
          criteria: criteria,
          isEnabled: !widget.isLoading,
          onChanged: (value) => setState(() => criteria = value),
        ),
        const SizedBox(height: 8),
        ...[
          Text(context.t.feed.ratingThreshold, style: headerStyle),
          FilterChipList(
            isEnabled: !widget.isLoading,
            options: FilterList.scoreOptions,
            isSelected: (option) => option.value == scoreValue.value,
            onSelected: (isSelected, option) => setState(() {
              scoreValue = option;
            }),
          ),
        ],
        const SizedBox(height: 10),
        PublicationFilterSubmitButton(
          isEnabled: !widget.isLoading && criteria.formats.isNotEmpty,
          onSubmit: () => widget.onSubmit(
            FeedFilter(score: scoreValue, criteria: criteria),
          ),
        ),
      ],
    );
  }
}
