import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/utils/utils.dart';
import '../../../../component/di/injector.dart';
import '../../../summary/cubit/summary_auth_cubit.dart';
import '../settings_card_widget.dart';

class SummaryTokenWidget extends StatefulWidget {
  const SummaryTokenWidget({super.key});

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

        return SettingsCardWidget(
          title: '300.ya token',
          subtitle: 'Для генерации пересказов статей',
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
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
                          getIt.get<Utils>().showSnack(
                                context: context,
                                content: const Text(
                                  'Скопировано в буфер обмена',
                                ),
                              );
                        },
                        child: const Text('Скопировать'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
