import 'package:flutter/material.dart';

import '../../../feature/enhancement/scaffold/widget/floating_drawer_button.dart';
import '../../../feature/enhancement/scroll/widget/floating_scroll_to_top_button.dart';

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({super.key});

  static get location => FloatingActionButtonLocation.centerFloat;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FloatingDrawerButton(),
          FloatingScrollToTopButton(),
        ],
      ),
    );
  }
}
