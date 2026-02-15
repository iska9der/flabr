part of 'scroll_cubit.dart';

class ScrollState with EquatableMixin {
  const ScrollState({
    this.isTopEdge = false,
    this.isBottomEdge = false,
    this.isScrollToTopVisible = false,
  });

  final bool isTopEdge;
  final bool isBottomEdge;
  final bool isScrollToTopVisible;

  bool get isBetweenEdge => !isTopEdge && !isBottomEdge;

  ScrollState copyWith({
    ScrollPosition? position,
    bool? isTopEdge,
    bool? isBottomEdge,
    bool? isScrollToTopVisible,
  }) {
    return ScrollState(
      isTopEdge: isTopEdge ?? this.isTopEdge,
      isBottomEdge: isBottomEdge ?? this.isBottomEdge,
      isScrollToTopVisible: isScrollToTopVisible ?? this.isScrollToTopVisible,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [
    isTopEdge,
    isBottomEdge,
    isScrollToTopVisible,
  ];
}
