part of 'scaffold_cubit.dart';

class ScaffoldCubitState with Equatable {
  const ScaffoldCubitState({required this.key});

  final GlobalKey<ScaffoldState> key;

  @override
  List<Object> get props => [key];
}
