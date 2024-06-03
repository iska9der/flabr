import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/widget/enhancement/progress_indicator.dart';
import '../cubit/summary_cubit.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryCubit, SummaryState>(
      builder: (context, state) {
        if (state.status == SummaryStatus.initial) {
          context.read<SummaryCubit>().fetchSummary();
        }

        return switch (state.status) {
          SummaryStatus.initial ||
          SummaryStatus.loading =>
            const CircleIndicator(),
          SummaryStatus.failure => Center(child: Text(state.error)),
          SummaryStatus.success => Scrollbar(
              thumbVisibility: true,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      state.model.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ...state.model.content.map((line) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text('• $line'),
                      ))
                ],
              ),
            ),
        };
      },
    );
  }
}
