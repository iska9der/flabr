import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/di/dependencies.dart';
import '../../../component/router/app_router.dart';
import '../cubit/summary_cubit.dart';
import '../repository/summary_repository.dart';
import 'summary_widget.dart';

Future showSummaryDialog(
  BuildContext context, {
  required String articleId,
}) async {
  return await showDialog(
    context: context,
    useSafeArea: true,
    useRootNavigator: false,
    builder: (context) => BlocProvider(
      create: (_) => SummaryCubit(
        articleId: articleId,
        repository: getIt.get<SummaryRepository>(),
      ),
      child: AlertDialog.adaptive(
        clipBehavior: Clip.hardEdge,
        insetPadding: const EdgeInsets.fromLTRB(6, 6, 6, 64),
        titlePadding: const EdgeInsets.all(18),
        actionsPadding: const EdgeInsets.all(12),
        contentPadding: EdgeInsets.zero,
        actions: [
          BlocBuilder<SummaryCubit, SummaryState>(
            builder: (context, state) {
              if (state.model.sharingUrl.isEmpty) {
                return const SizedBox();
              }

              return TextButton(
                onPressed: () => getIt.get<AppRouter>().launchUrl(
                      state.model.sharingUrl,
                    ),
                child: const Text('Ссылка на пересказ'),
              );
            },
          ),
        ],
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
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const SummaryWidget(),
        ),
      ),
    ),
  );
}
