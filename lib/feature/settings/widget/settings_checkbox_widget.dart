import 'package:flutter/material.dart';

class SettingsCheckboxWidget extends StatefulWidget {
  const SettingsCheckboxWidget({
    Key? key,
    required this.initialValue,
    required this.title,
    this.subtitle,
    this.validate,
    required this.onChanged,
  }) : super(key: key);

  final bool initialValue;
  final Widget title;
  final Widget? subtitle;
  final bool Function(bool value)? validate;
  final void Function(bool value) onChanged;

  @override
  State<SettingsCheckboxWidget> createState() => _SettingsCheckboxWidgetState();
}

class _SettingsCheckboxWidgetState extends State<SettingsCheckboxWidget> {
  bool isChecked = false;

  @override
  void initState() {
    isChecked = widget.initialValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      contentPadding: EdgeInsets.zero,
      value: isChecked,
      onChanged: (bool? value) {
        if (value == null) return;

        bool isValidated = true;

        if (widget.validate != null) {
          isValidated = widget.validate!(value);
        }

        if (isValidated) {
          setState(() {
            isChecked = value;
          });

          Future.delayed(
            const Duration(milliseconds: 300),
            () {
              widget.onChanged(value);
            },
          );
        }
      },
    );
  }
}
