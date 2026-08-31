import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../i18n/i18n.dart';
import '../../../presentation/extension/extension.dart';
import '../cubit/summary_auth_cubit.dart';

class SummaryTokenWidget extends StatefulWidget {
  const SummaryTokenWidget({super.key});

  @override
  State<SummaryTokenWidget> createState() => _SummaryTokenWidgetState();
}

class _SummaryTokenWidgetState extends State<SummaryTokenWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SummaryAuthCubit, SummaryAuthState>(
      builder: (context, state) {
        _controller.text = state.isAuthorized ? state.token : '';

        return Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            TextFormField(
              onTapOutside: (_) =>
                  FocusManager.instance.primaryFocus?.unfocus(),
              enabled: !state.isAuthorized,
              controller: _controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                floatingLabelBehavior: .always,
                labelText: context.t.summary.token.label,
                hintText: context.t.summary.token.locationHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (state.isAuthorized)
                  ElevatedButton(
                    onPressed: () => context.read<SummaryAuthCubit>().logOut(),
                    child: Text(context.t.common.clear),
                  )
                else
                  FilledButton(
                    onPressed: () => context.read<SummaryAuthCubit>().saveToken(
                      _controller.text,
                    ),
                    child: Text(context.t.common.save),
                  ),
                const SizedBox(width: 12),
                if (state.isAuthorized)
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _controller.text));
                      context.showSnack(
                        content: Text(context.t.common.copiedToClipboard),
                      );
                    },
                    child: Text(context.t.common.copy),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
