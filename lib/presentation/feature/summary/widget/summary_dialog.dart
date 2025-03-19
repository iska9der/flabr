import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/repository/part.dart';
import '../cubit/summary_auth_cubit.dart';
import '../cubit/summary_cubit.dart';
import 'summary_token_widget.dart';
import 'summary_widget.dart';

Future showSummaryDialog(
  BuildContext context, {
  required String publicationId,
  required SummaryRepository repository,
  Widget? loaderWidget,

  /// обработчик нажатия: ссылка на пересказ
  Function(String)? onLinkPressed,
}) async {
  final theme = Theme.of(context);
  final barrierColor = theme.colorScheme.surface.withValues(alpha: .8);

  return await showDialog(
    context: context,
    barrierColor: barrierColor,
    builder: (context) => BlocProvider.value(
      value: BlocProvider.of<SummaryAuthCubit>(context),
      child: BlocProvider(
        create: (_) => SummaryCubit(
          publicationId: publicationId,
          repository: repository,
        ),
        child: BlocBuilder<SummaryAuthCubit, SummaryAuthState>(
          builder: (context, authState) {
            return AlertDialog(
              clipBehavior: Clip.hardEdge,
              insetPadding: const EdgeInsets.fromLTRB(6, 6, 6, 64),
              titlePadding: const EdgeInsets.all(18),
              actionsPadding: const EdgeInsets.all(12),
              contentPadding: EdgeInsets.zero,
              backgroundColor: theme.colorScheme.surfaceContainerLow,
              shadowColor: theme.colorScheme.shadow,
              alignment: Alignment.center,
              actions: switch (authState.status) {
                SummaryAuthStatus.authorized => [
                    BlocBuilder<SummaryCubit, SummaryState>(
                      builder: (context, state) {
                        if (onLinkPressed == null ||
                            state.model.sharingUrl.isEmpty) {
                          return const SizedBox();
                        }

                        return TextButton(
                          onPressed: () =>
                              onLinkPressed(state.model.sharingUrl),
                          child: const Text('Ссылка на пересказ'),
                        );
                      },
                    ),
                  ],
                _ => [],
              },
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('YandexGPT'),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'краткий пересказ статьи от нейросети',
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
                SummaryAuthStatus.loading when loaderWidget != null =>
                  loaderWidget,
                SummaryAuthStatus.unauthorized => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SummaryTokenWidget(),
                      ],
                    ),
                  ),
                SummaryAuthStatus.authorized => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: const SummaryWidget(),
                  ),
                _ => const SizedBox(),
              },
            );
          },
        ),
      ),
    ),
  );
}
