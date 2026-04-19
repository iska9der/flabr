import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../presentation/theme/theme.dart';
import '../cubit/scroll_cubit.dart';

/// До того как использовать, нужно
/// создать [ScrollCubit] выше по дереву
class FloatingScrollToTopButton extends StatelessWidget {
  const FloatingScrollToTopButton({super.key});

  @override
  Widget build(BuildContext context) {
    final visible = context.select<ScrollCubit, bool>(
      (cubit) => cubit.state.isScrollToTopVisible,
    );

    return AnimatedOpacity(
      duration: AppStyles.hideDuration,
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
