import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/widget/error_widget.dart';
import '../cubit/summary_cubit.dart';

class SummaryWidget extends StatefulWidget {
  const SummaryWidget({super.key, this.loaderWidget});

  final Widget? loaderWidget;

  @override
  State<SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<SummaryWidget> {
  @override
  void initState() {
    super.initState();
    context.read<SummaryCubit>().fetchSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BlocBuilder<SummaryCubit, SummaryState>(
        builder: (context, state) {
          return switch (state.status) {
            SummaryStatus.initial || SummaryStatus.loading =>
              widget.loaderWidget ??
                  const Center(child: CircularProgressIndicator()),
            SummaryStatus.failure => AppError(
              error: state.error,
              onRetry: () => context.read<SummaryCubit>().fetchSummary(),
            ),
            SummaryStatus.success => Scrollbar(
              thumbVisibility: true,
              child: ListView(
                padding: const .symmetric(horizontal: 16),
                children: [
                  Padding(
                    padding: const .only(bottom: 12),
                    child: Text(
                      state.model.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ...state.model.content.map(
                    (line) => Padding(
                      padding: const .only(bottom: 8),
                      child: Text('• $line'),
                    ),
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}
