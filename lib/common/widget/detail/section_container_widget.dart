import 'package:flutter/material.dart';

class SectionContainerWidget extends StatelessWidget {
  const SectionContainerWidget({
    Key? key,
    required this.title,
    required this.child,
    this.crossAxisAlignment = CrossAxisAlignment.stretch,
  }) : super(key: key);

  final String title;
  final Widget child;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
