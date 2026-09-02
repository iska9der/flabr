import 'package:flutter/material.dart';

class SettingsSegmentedButton<T> extends StatelessWidget {
  const SettingsSegmentedButton({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  final List<ButtonSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments,
      selected: {value},
      expandedInsets: .zero,
      showSelectedIcon: false,
      style: const ButtonStyle(
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.padded,
      ),
      onSelectionChanged: (selection) => onChanged(selection.single),
    );
  }
}
