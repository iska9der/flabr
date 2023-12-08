import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/widget/enhancement/progress_indicator.dart';
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
          SummaryStatus.success => ListView(
              children: state.model.content.map((line) => Text(line)).toList(),
            ),
        };
      },
    );
  }
}
