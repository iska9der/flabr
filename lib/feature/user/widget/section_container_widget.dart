import 'package:flutter/material.dart';

class SectionContainerWidget extends StatelessWidget {
  const SectionContainerWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}
