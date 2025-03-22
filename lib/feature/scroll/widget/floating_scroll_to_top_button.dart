import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    var scrollCubit = context.read<ScrollCubit>();
    var scrollCtrl = scrollCubit.state.controller;

    return AnimatedBuilder(
      animation: scrollCtrl,
      builder: (context, child) {
        bool visible = isVisible.value;

        if (scrollCtrl.positions.isNotEmpty) {
          final topEdge = scrollCubit.state.isTopEdge;
          final direction = scrollCtrl.position.userScrollDirection;
          if (topEdge || direction == ScrollDirection.reverse) {
            visible = false;
          } else if (direction == ScrollDirection.forward) {
            visible = true;
          }
        }

        isVisible.value = visible;

        return IgnorePointer(
          ignoring: !isVisible.value,
          child: AnimatedOpacity(
            duration: scrollCubit.duration,
            opacity: isVisible.value ? 1 : 0,
            child: child,
          ),
        );
      },
      child: FloatingActionButton(
        heroTag: null,
        mini: true,
        onPressed: () => scrollCubit.animateToTop(),
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
