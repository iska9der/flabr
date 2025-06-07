import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.linear,
    this.edgeTolerance = 20.0,
  }) : super(ScrollState(controller: ScrollController())) {
    _initListeners();
  }

  final Duration duration;
  final Curve curve;
  final double edgeTolerance;

  @override
  Future<void> close() {
    state.controller.removeListener(_onScroll);
    state.controller.dispose();

    return super.close();
  }

  void _initListeners() {
    emit(state.copyWith(isTopEdge: true));

    state.controller.addListener(_onScroll);
  }

  void _onScroll() {
    final controller = state.controller;
    final position = controller.position;

    final isTopEdge =
        position.pixels <= position.minScrollExtent + edgeTolerance;
    final isBottomEdge =
        position.pixels >= position.maxScrollExtent - edgeTolerance;
    final direction = position.userScrollDirection;
    final isScrollToTopVisible =
        !isTopEdge && direction == ScrollDirection.forward;

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

  Future<void> animateTo(
    double offset, {
    Duration? duration,
    Curve? curve,
  }) async {
    await state.controller.animateTo(
      offset,
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  Future<void> animateToTop({Duration? duration, Curve? curve}) async {
    await animateTo(0.00, duration: duration, curve: curve);
  }

  Future<void> animateToBottom({Duration? duration, Curve? curve}) async {
    await animateTo(
      state.controller.position.maxScrollExtent,
      duration: duration,
      curve: curve,
    );
  }
}
