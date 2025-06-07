import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget _buildRefreshIndicator(
  BuildContext context,
  RefreshIndicatorMode refreshState,
  double pulledExtent,
  double refreshTriggerPullDistance,
  double refreshIndicatorExtent,
) {
  const Curve opacityCurve = Interval(0.4, 0.8, curve: Curves.easeInOut);
  const duration = Duration(milliseconds: 200);

  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: switch (refreshState) {
        RefreshIndicatorMode.drag => AnimatedOpacity(
          duration: duration,
          opacity: opacityCurve.transform(
            min(pulledExtent / refreshTriggerPullDistance, 1.0),
          ),
          child: const Icon(
            Icons.arrow_downward,
            color: CupertinoColors.inactiveGray,
            size: 24.0,
          ),
        ),
        RefreshIndicatorMode.inactive => const SizedBox.shrink(),
        _ => AnimatedOpacity(
          duration: duration,
          opacity: opacityCurve.transform(
            min(pulledExtent / refreshIndicatorExtent, 1.0),
          ),
          child: const RefreshProgressIndicator(),
        ),
      },
    ),
  );
}

class FlabrSliverRefreshIndicator extends StatelessWidget {
  const FlabrSliverRefreshIndicator({super.key, this.onRefresh});

  final FutureOr<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh != null ? () async => onRefresh?.call() : null,
      builder: _buildRefreshIndicator,
    );
  }
}

class FlabrRefreshIndicator extends StatelessWidget {
  const FlabrRefreshIndicator({
    super.key,
    required this.onRefresh,
    required this.child,
  });

  final FutureOr<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh.call(),
      child: child,
    );
  }
}
