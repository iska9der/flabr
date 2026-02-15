part of 'scaffold_cubit.dart';

class ScaffoldCubitState with EquatableMixin {
  const ScaffoldCubitState({required this.key});

  final GlobalKey<ScaffoldState> key;

  @override
  List<Object> get props => [key];
}
