import 'package:flutter/material.dart';

import '../../../i18n/i18n.dart';

class PublicationFilterSubmitButton extends StatelessWidget {
  const PublicationFilterSubmitButton({
    super.key,
    this.isEnabled = true,
    required this.onSubmit,
  });

  final bool isEnabled;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isEnabled ? onSubmit : null,
      child: Text(context.t.filter.apply),
    );
  }
}
