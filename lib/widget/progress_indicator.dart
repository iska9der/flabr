import 'package:flutter/material.dart';

enum IndicatorSize {
  small(10, 1),
  medium(20, 2),
  large(40, 3);

  const IndicatorSize(this.height, this.strokeWidth);

  final double height;
  final double strokeWidth;
}

class CircleIndicator extends StatelessWidget {
  const CircleIndicator({super.key, this.size = IndicatorSize.large});

  const CircleIndicator.small({super.key, this.size = IndicatorSize.small});

  const CircleIndicator.medium({super.key, this.size = IndicatorSize.medium});

  final IndicatorSize size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: size.height,
        width: size.height,
        child: CircularProgressIndicator.adaptive(
          strokeWidth: size.strokeWidth,
        ),
      ),
    );
  }
}
