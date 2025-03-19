import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/summary_auth_cubit.dart';

class SummaryTokenWidget extends StatefulWidget {
  const SummaryTokenWidget({super.key, this.onShowSnack});

  final void Function(String)? onShowSnack;

  @override
  State<SummaryTokenWidget> createState() => _SummaryTokenWidgetState();
}

class _SummaryTokenWidgetState extends State<SummaryTokenWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryAuthCubit, SummaryAuthState>(
      builder: (context, state) {
        if (state.isAuthorized) {
          controller.text = state.token;
        } else {
          controller.text = '';
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              onTapOutside: (event) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              enabled: !state.isAuthorized,
              controller: controller,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelText: 'Токен',
                hintText: 'Можно найти на 300.ya.ru',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                state.isAuthorized
                    ? ElevatedButton(
                        onPressed: () {
                          context.read<SummaryAuthCubit>().logOut();
                        },
                        child: const Text('Очистить'),
                      )
                    : FilledButton(
                        onPressed: () {
                          context.read<SummaryAuthCubit>().saveToken(
                                controller.text,
                              );
                        },
                        child: const Text('Сохранить'),
                      ),
                const SizedBox(width: 12),
                if (state.isAuthorized)
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(text: controller.text),
                      );

                      widget.onShowSnack?.call('Скопировано в буфер обмена');
                    },
                    child: const Text('Скопировать'),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
