import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit({
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.linear,
  }) : super(ScrollState(controller: ScrollController()));

  final Duration duration;
  final Curve curve;

  @override
  Future<void> close() {
    state.controller.dispose();
    return super.close();
  }

  void setUpEdgeListeners() {
    emit(state.copyWith(isTopEdge: true));

    state.controller.addListener(() {
      _setBottomEdgeListener();
      _setTopEdgeListener();
    });
  }

  void _setTopEdgeListener() {
    if (state.controller.position.atEdge &&
        state.controller.position.pixels == 0) {
      if (!state.isTopEdge) emit(state.copyWith(isTopEdge: true));
    } else {
      if (state.isTopEdge) emit(state.copyWith(isTopEdge: false));
    }
  }

  _setBottomEdgeListener() {
    if (state.controller.position.atEdge &&
        state.controller.position.pixels != 0) {
      if (!state.isBottomEdge) emit(state.copyWith(isBottomEdge: true));
    } else {
      if (state.isBottomEdge) emit(state.copyWith(isBottomEdge: false));
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
