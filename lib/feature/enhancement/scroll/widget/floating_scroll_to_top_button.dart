import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/scroll_cubit.dart';

/// До того как использовать, нужно
/// создать [ScrollCubit] выше по дереву
class FloatingScrollToTopButton extends StatelessWidget {
  const FloatingScrollToTopButton({super.key});

  @override
  Widget build(BuildContext context) {
    var scrollCubit = context.read<ScrollCubit>();

    return BlocBuilder<ScrollCubit, ScrollState>(
      builder: (context, state) {
        return AnimatedOpacity(
          duration: scrollCubit.duration,
          opacity: state.isTopEdge ? 0 : 1,
          child: FloatingActionButton(
            heroTag: null,
            mini: true,
            onPressed: () => scrollCubit.animateToTop(),
            child: const Icon(Icons.arrow_upward),
          ),
        );
      },
    );
  }
}
