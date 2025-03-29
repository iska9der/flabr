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
    var state = context.select<ScrollCubit, ScrollState>(
      (value) => value.state,
    );

    if (!state.controller.hasClients) {
      return const SizedBox();
    }

    return AnimatedBuilder(
      animation: state.controller.position.isScrollingNotifier,
      builder: (context, child) {
        bool visible = isVisible.value;

        if (state.controller.positions.isNotEmpty) {
          final topEdge = state.isTopEdge;
          final direction = state.controller.position.userScrollDirection;
          if (topEdge || direction == ScrollDirection.reverse) {
            visible = false;
          } else if (direction == ScrollDirection.forward) {
            visible = true;
          }
        }

        if (visible != isVisible.value) {
          isVisible.value = visible;
        }

        return AnimatedOpacity(
          duration: context.read<ScrollCubit>().duration,
          opacity: isVisible.value ? 1 : 0,
          child: IgnorePointer(ignoring: !isVisible.value, child: child),
        );
      },
      child: FloatingActionButton(
        heroTag: null,
        mini: true,
        onPressed: () => context.read<ScrollCubit>().animateToTop(),
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}
