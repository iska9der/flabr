import 'package:flutter/material.dart';

import '../../feature/scaffold/widget/floating_drawer_button.dart';
import '../../feature/scroll/widget/floating_scroll_to_top_button.dart';

class CommonFloatingActionButton extends StatelessWidget {
  const CommonFloatingActionButton({super.key});

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
