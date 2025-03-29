import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/model/filter/filter.dart';
import '../../../../../feature/auth/auth.dart';
import '../../../../../feature/publication_list/publication_list.dart';
import '../../../../widget/filter/filter_chip_list.dart';
import '../../../../widget/filter/publication_filter_submit_button.dart';
import '../cubit/feed_publication_list_cubit.dart';

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
              isLoading: state.status == PublicationListStatus.loading,
              currentScore: state.filter.score,
              currentTypes: state.filter.types,
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
    // ignore: unused_element_parameter
    super.key,
    this.isLoading = false,
    required this.currentScore,
    required this.currentTypes,
    required this.onSubmit,
  });

  final bool isLoading;

  final FilterOption currentScore;

  final List<FeedFilterPublication> currentTypes;
  final Function(FeedFilter filter) onSubmit;

  @override
  State<_FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<_FilterView> {
  late FilterOption scoreValue = widget.currentScore;
  late List<FeedFilterPublication> typesValue = widget.currentTypes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Тип публикации', style: Theme.of(context).textTheme.labelLarge),
        FilterChipList(
          isEnabled: !widget.isLoading,
          options:
              FeedFilterPublication.values
                  .map((e) => FilterOption(label: e.label, value: e.name))
                  .toList(),
          isSelected:
              (option) => typesValue.contains(
                FeedFilterPublication.fromString(option.value),
              ),
          onSelected: (isSelected, newOption) {
            final newType = FeedFilterPublication.fromString(newOption.value);

            List<FeedFilterPublication> newTypes;
            if (isSelected) {
              newTypes = [...typesValue, newType];
            } else {
              newTypes = [...typesValue]
                ..removeWhere((element) => element == newType);
            }

            if (newTypes.isEmpty) {
              return;
            }

            setState(() {
              typesValue = newTypes;
            });
          },
        ),
        const SizedBox(height: 12),
        Text('Порог рейтинга', style: Theme.of(context).textTheme.labelLarge),
        FilterChipList(
          isEnabled: !widget.isLoading,
          options: FilterList.scoreOptions,
          isSelected: (option) => option == scoreValue,
          onSelected:
              (isSelected, option) => setState(() {
                scoreValue = option;
              }),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: PublicationFilterSubmitButton(
            isEnabled: !widget.isLoading,
            onSubmit:
                () => widget.onSubmit(
                  FeedFilter(score: scoreValue, types: typesValue),
                ),
          ),
        ),
      ],
    );
  }
}
