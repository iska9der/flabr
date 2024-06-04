part of '../part.dart';

class ScaffoldCubitState extends Equatable {
  const ScaffoldCubitState({required this.key});

  final GlobalKey<ScaffoldState> key;

  @override
  List<Object> get props => [key];
}
