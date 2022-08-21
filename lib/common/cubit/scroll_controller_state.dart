// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'scroll_controller_cubit.dart';

class ScrollControllerState extends Equatable {
  const ScrollControllerState({
    required this.controller,
    this.isTopEdge = false,
    this.isBottomEdge = false,
  });

  final ScrollController controller;
  final bool isTopEdge;
  final bool isBottomEdge;

  bool get isBetweenEdge => !isTopEdge && !isBottomEdge;

  ScrollControllerState copyWith({
    ScrollController? controller,
    ScrollPosition? position,
    bool? isTopEdge,
    bool? isBottomEdge,
  }) {
    return ScrollControllerState(
      controller: controller ?? this.controller,
      isTopEdge: isTopEdge ?? this.isTopEdge,
      isBottomEdge: isBottomEdge ?? this.isBottomEdge,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [controller, isTopEdge, isBottomEdge];
}
