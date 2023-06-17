import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/scaffold_cubit.dart';

class FloatingDrawerButton extends StatelessWidget {
  const FloatingDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      onPressed: () => context
          .read<ScaffoldCubit>()
          .key
          .currentState
          ?.openDrawer(),
      child: const Icon(Icons.menu),
    );
  }
}
