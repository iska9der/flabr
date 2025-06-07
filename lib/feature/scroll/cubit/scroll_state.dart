part of 'scroll_cubit.dart';

class ScrollState extends Equatable {
  const ScrollState({
    required this.controller,
    this.isTopEdge = false,
    this.isBottomEdge = false,
    this.isScrollToTopVisible = false,
  });

  final ScrollController controller;
  final bool isTopEdge;
  final bool isBottomEdge;
  final bool isScrollToTopVisible;

  bool get isBetweenEdge => !isTopEdge && !isBottomEdge;

  ScrollState copyWith({
    ScrollController? controller,
    ScrollPosition? position,
    bool? isTopEdge,
    bool? isBottomEdge,
    bool? isScrollToTopVisible,
  }) {
    return ScrollState(
      controller: controller ?? this.controller,
      isTopEdge: isTopEdge ?? this.isTopEdge,
      isBottomEdge: isBottomEdge ?? this.isBottomEdge,
      isScrollToTopVisible: isScrollToTopVisible ?? this.isScrollToTopVisible,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    controller,
    isTopEdge,
    isBottomEdge,
    isScrollToTopVisible,
  ];
}
