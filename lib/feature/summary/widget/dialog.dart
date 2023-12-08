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
    barrierColor: Colors.transparent,
    builder: (context) => BlocProvider(
      create: (_) => SummaryCubit(
        articleId: articleId,
        repository: getIt.get<SummaryRepository>(),
      ),
      child: AlertDialog.adaptive(
        insetPadding: const EdgeInsets.symmetric(vertical: 12),
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
            const Text('Кратко'),
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
