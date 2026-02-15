import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit({
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.linear,
    double edgeTolerance = 20.0,
  }) : _edgeTolerance = edgeTolerance,
       _curve = curve,
       _duration = duration,
       super(const ScrollState()) {
    _initListeners();
  }

  final ScrollController _controller = .new();
  final Duration _duration;
  final Curve _curve;
  final double _edgeTolerance;

  ScrollController get controller => _controller;
  Duration get duration => _duration;

  @override
  Future<void> close() {
    _controller.removeListener(_onScroll);
    _controller.dispose();

    return super.close();
  }

  void _initListeners() {
    emit(state.copyWith(isTopEdge: true));

    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final position = _controller.position;

    final isTopEdge =
        position.pixels <= position.minScrollExtent + _edgeTolerance;
    final isBottomEdge =
        position.pixels >= position.maxScrollExtent - _edgeTolerance;
    final direction = position.userScrollDirection;
    final isScrollToTopVisible = !isTopEdge && direction == .forward;

    if (isTopEdge != state.isTopEdge ||
        isBottomEdge != state.isBottomEdge ||
        isScrollToTopVisible != state.isScrollToTopVisible) {
      emit(
        state.copyWith(
          isTopEdge: isTopEdge,
          isBottomEdge: isBottomEdge,
          isScrollToTopVisible: isScrollToTopVisible,
        ),
      );
    }
  }

  Future<void> _animateTo(
    double offset, {
    Duration? duration,
    Curve? curve,
  }) async {
    await _controller.animateTo(
      offset,
      duration: duration ?? this.duration,
      curve: curve ?? _curve,
    );
  }

  Future<void> animateToTop({Duration? duration, Curve? curve}) async {
    await _animateTo(0.00, duration: duration, curve: curve);
  }

  Future<void> animateToBottom({Duration? duration, Curve? curve}) async {
    await _animateTo(
      _controller.position.maxScrollExtent,
      duration: duration,
      curve: curve,
    );
  }
}
