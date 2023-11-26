import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_value.dart';

/// Эквивалент [ResponsiveVisibility] для сливеров.
class ResponsiveVisibilitySliver extends StatelessWidget {
  final Widget sliver;
  final bool visible;
  final List<Condition> visibleConditions;
  final List<Condition> hiddenConditions;
  final Widget replacementSliver;
  final bool maintainState;
  final bool maintainAnimation;
  final bool maintainSize;
  final bool maintainSemantics;
  final bool maintainInteractivity;

  const ResponsiveVisibilitySliver({
    super.key,
    required this.sliver,
    this.visible = true,
    this.visibleConditions = const [],
    this.hiddenConditions = const [],
    this.replacementSliver = const SliverToBoxAdapter(),
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.maintainInteractivity = false,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize mutable value holders.
    List<Condition> conditions = [];
    bool? visibleValue = visible;

    // Combine Conditions.
    conditions.addAll(visibleConditions.map((e) => e.copyWith(value: true)));
    conditions.addAll(hiddenConditions.map((e) => e.copyWith(value: false)));
    // Get visible value from active condition.
    visibleValue = ResponsiveValue(context,
            defaultValue: visibleValue, conditionalValues: conditions)
        .value;

    return SliverVisibility(
      replacementSliver: replacementSliver,
      visible: visibleValue!,
      maintainState: maintainState,
      maintainAnimation: maintainAnimation,
      maintainSize: maintainSize,
      maintainSemantics: maintainSemantics,
      maintainInteractivity: maintainInteractivity,
      sliver: sliver,
    );
  }
}
