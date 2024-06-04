part of '../part.dart';

class FloatingDrawerButton extends StatelessWidget {
  const FloatingDrawerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: null,
      mini: true,
      onPressed: () =>
          context.read<ScaffoldCubit>().key.currentState?.openDrawer(),
      child: const Icon(Icons.menu),
    );
  }
}
