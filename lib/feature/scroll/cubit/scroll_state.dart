part of 'scroll_cubit.dart';

class ScrollState with EquatableMixin {
  const ScrollState({
    this.isTopEdge = false,
    this.isBottomEdge = false,
    this.isScrollToTopVisible = false,
    this.scrollProgress = 0,
  });

  final bool isTopEdge;
  final bool isBottomEdge;
  final bool isScrollToTopVisible;
  final double scrollProgress;

  bool get isBetweenEdge => !isTopEdge && !isBottomEdge;

  ScrollState copyWith({
    ScrollPosition? position,
    bool? isTopEdge,
    bool? isBottomEdge,
    bool? isScrollToTopVisible,
    double? scrollProgress,
  }) {
    return ScrollState(
      isTopEdge: isTopEdge ?? this.isTopEdge,
      isBottomEdge: isBottomEdge ?? this.isBottomEdge,
      isScrollToTopVisible: isScrollToTopVisible ?? this.isScrollToTopVisible,
      scrollProgress: scrollProgress ?? this.scrollProgress,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    isTopEdge,
    isBottomEdge,
    isScrollToTopVisible, scrollProgress
  ];
}
