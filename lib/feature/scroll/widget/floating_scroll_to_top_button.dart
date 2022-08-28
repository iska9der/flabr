import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/scroll_controller_cubit.dart';

/// До того как использовать, нужно
/// создать [ScrollControllerCubit] выше по дереву
class FloatingScrollToTopButton extends StatelessWidget {
  const FloatingScrollToTopButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scrollCubit = context.read<ScrollControllerCubit>();

    return BlocBuilder<ScrollControllerCubit, ScrollControllerState>(
      builder: (context, state) {
        return AnimatedOpacity(
          duration: scrollCubit.duration,
          opacity: state.isTopEdge ? 0 : 1,
          child: FloatingActionButton(
            mini: true,
            onPressed: () => scrollCubit.animateToTop(),
            child: const Icon(Icons.arrow_upward),
          ),
        );
      },
    );
  }
}
