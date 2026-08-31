import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/summary_repository.dart';
import '../../../i18n/i18n.dart';
import '../cubit/summary_auth_cubit.dart';
import '../cubit/summary_cubit.dart';
import 'summary_token_widget.dart';
import 'summary_widget.dart';

Future<void> showSummaryDialog(
  BuildContext context, {
  required String url,
  required SummaryRepository repository,
  Widget? loaderWidget,
  void Function(String)? onLinkPressed,
}) async {
  final theme = Theme.of(context);
  final barrierColor = theme.colorScheme.surface.withValues(alpha: .8);
  final loader =
      loaderWidget ?? const Center(child: CircularProgressIndicator());

  await showDialog<void>(
    context: context,
    barrierColor: barrierColor,
    builder: (context) => MultiBlocProvider(
      providers: [
        BlocProvider<SummaryAuthCubit>.value(
          value: context.read<SummaryAuthCubit>(),
        ),
        BlocProvider(
          create: (_) => SummaryCubit(url: url, repository: repository),
        ),
      ],
      child: BlocBuilder<SummaryAuthCubit, SummaryAuthState>(
        builder: (context, authState) {
          return AlertDialog(
            clipBehavior: Clip.hardEdge,
            insetPadding: const .fromLTRB(6, 6, 6, 64),
            titlePadding: const .all(18),
            actionsPadding: const .all(12),
            contentPadding: .zero,
            backgroundColor: theme.colorScheme.surfaceContainerLow,
            shadowColor: theme.colorScheme.shadow,
            alignment: .center,
            actions: switch (authState.status) {
              SummaryAuthStatus.authorized => [
                BlocBuilder<SummaryCubit, SummaryState>(
                  builder: (context, state) {
                    if (onLinkPressed == null ||
                        state.model.sharingUrl.isEmpty) {
                      return const SizedBox();
                    }

                    return TextButton(
                      onPressed: () => onLinkPressed(state.model.sharingUrl),
                      child: Text(context.t.summary.link.label),
                    );
                  },
                ),
              ],
              _ => null,
            },
            title: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: .stretch,
                    children: [
                      const Text('YandexGPT'),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: .centerLeft,
                        child: Text(
                          context.t.summary.aiDescription,
                          style: DefaultTextStyle.of(context).style,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            content: switch (authState.status) {
              SummaryAuthStatus.loading => loader,
              SummaryAuthStatus.unauthorized => const Padding(
                padding: .symmetric(horizontal: 12),
                child: Column(
                  mainAxisSize: .min,
                  mainAxisAlignment: .center,
                  children: [SummaryTokenWidget()],
                ),
              ),
              SummaryAuthStatus.authorized => SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: SummaryWidget(loaderWidget: loader),
              ),
              _ => const SizedBox(),
            },
          );
        },
      ),
    ),
  );
}
