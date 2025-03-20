part of 'scroll_cubit.dart';

class ScrollState extends Equatable {
  const ScrollState({
    required this.controller,
    this.isTopEdge = false,
    this.isBottomEdge = false,
  });

  final ScrollController controller;
  final bool isTopEdge;
  final bool isBottomEdge;

  bool get isBetweenEdge => !isTopEdge && !isBottomEdge;

  ScrollState copyWith({
    ScrollController? controller,
    ScrollPosition? position,
    bool? isTopEdge,
    bool? isBottomEdge,
  }) {
    return ScrollState(
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
