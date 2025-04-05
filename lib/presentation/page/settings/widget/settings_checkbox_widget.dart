import 'package:flutter/material.dart';

enum SettingsCheckboxType { checkboxTile, switchTile }

class SettingsCheckboxWidget extends StatefulWidget {
  const SettingsCheckboxWidget({
    super.key,
    required this.initialValue,
    required this.title,
    this.subtitle,
    this.type = SettingsCheckboxType.switchTile,
    this.validate,
    required this.onChanged,
  });

  final bool initialValue;
  final Widget title;
  final Widget? subtitle;
  final SettingsCheckboxType type;
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

  void onChanged(bool? value) {
    if (value == null) return;

    bool isValidated = true;

    if (widget.validate != null) {
      isValidated = widget.validate!(value);
    }

    if (isValidated) {
      setState(() => isChecked = value);

      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onChanged(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.type) {
      SettingsCheckboxType.checkboxTile => CheckboxListTile(
        title: widget.title,
        subtitle: widget.subtitle,
        contentPadding: EdgeInsets.zero,
        value: isChecked,
        onChanged: onChanged,
      ),
      SettingsCheckboxType.switchTile => SwitchListTile(
        title: widget.title,
        subtitle: widget.subtitle,
        contentPadding: EdgeInsets.zero,
        value: isChecked,
        onChanged: onChanged,
      ),
    };
  }
}
