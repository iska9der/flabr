import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TypeDropdownMenu<C extends Cubit<S>, S> extends StatelessWidget {
  const TypeDropdownMenu({
    super.key,
    required this.type,
    required this.onChanged,
    required this.entries,
  });

  final String type;
  final ValueChanged<String> onChanged;
  final List<DropdownMenuItem<String>> entries;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: type,
      underline: const SizedBox.shrink(),
      alignment: Alignment.centerLeft,
      onChanged: (value) {
        if (value == null) {
          return;
        }

        onChanged.call(value);
      },
      items: entries,
    );
  }
}
