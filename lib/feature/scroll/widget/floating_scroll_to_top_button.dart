import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/scroll_cubit.dart';

/// До того как использовать, нужно
/// создать [ScrollCubit] выше по дереву
class FloatingScrollToTopButton extends StatefulWidget {
  const FloatingScrollToTopButton({super.key});

  @override
  State<FloatingScrollToTopButton> createState() =>
      _FloatingScrollToTopButtonState();
}

class _FloatingScrollToTopButtonState extends State<FloatingScrollToTopButton> {
  ValueNotifier<bool> isVisible = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    final visible = context.select<ScrollCubit, bool>(
      (cubit) => cubit.state.isScrollToTopVisible,
    );

    return AnimatedOpacity(
      duration: context.read<ScrollCubit>().duration,
      opacity: visible ? 1 : 0,
      child: IgnorePointer(
        ignoring: !visible,
        child: FloatingActionButton(
          heroTag: null,
          mini: true,
          onPressed: () => context.read<ScrollCubit>().animateToTop(),
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }
}
