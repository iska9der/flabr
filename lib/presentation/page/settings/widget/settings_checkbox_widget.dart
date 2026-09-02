import 'package:flutter/material.dart';

enum SettingsCheckboxType { checkboxTile, switchTile }

class SettingsCheckboxWidget extends StatefulWidget {
  const SettingsCheckboxWidget({
    super.key,
    required this.initialValue,
    required this.title,
    this.subtitle,
    this.icon,
    this.type = .switchTile,
    this.validate,
    required this.onChanged,
  });

  final bool initialValue;
  final Widget title;
  final Widget? subtitle;
  final IconData? icon;
  final SettingsCheckboxType type;
  final bool Function(bool value)? validate;
  final void Function(bool value) onChanged;

  @override
  State<SettingsCheckboxWidget> createState() => _SettingsCheckboxWidgetState();
}

class _SettingsCheckboxWidgetState extends State<SettingsCheckboxWidget> {
  late bool isChecked;

  @override
  void initState() {
    super.initState();

    isChecked = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant SettingsCheckboxWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialValue != widget.initialValue) {
      isChecked = widget.initialValue;
    }
  }

  void onChanged(bool? value) {
    if (value == null || widget.validate?.call(value) == false) {
      return;
    }

    setState(() => isChecked = value);
    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final control = switch (widget.type) {
      .checkboxTile => Checkbox(value: isChecked, onChanged: onChanged),
      .switchTile => Switch(value: isChecked, onChanged: onChanged),
    };

    return Semantics(
      toggled: isChecked,
      child: MergeSemantics(
        child: ListTile(
          minTileHeight: 64,
          contentPadding: const .symmetric(horizontal: 4, vertical: 2),
          visualDensity: VisualDensity.standard,
          shape: RoundedRectangleBorder(borderRadius: .circular(16)),
          leading: widget.icon == null
              ? null
              : DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius: .circular(12),
                  ),
                  child: SizedBox.square(
                    dimension: 40,
                    child: Icon(
                      widget.icon,
                      size: 21,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
          title: DefaultTextStyle.merge(
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: .w500,
            ),
            child: widget.title,
          ),
          subtitle: widget.subtitle == null
              ? null
              : DefaultTextStyle.merge(
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  child: widget.subtitle!,
                ),
          trailing: ExcludeSemantics(child: control),
          onTap: () => onChanged(!isChecked),
        ),
      ),
    );
  }
}
