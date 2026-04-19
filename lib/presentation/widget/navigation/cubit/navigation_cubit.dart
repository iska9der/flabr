import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void show() {
    if (state.isNavigationVisible) {
      return;
    }

    emit(state.copyWith(isNavigationVisible: true));
  }

  void hide() {
    if (!state.isNavigationVisible) {
      return;
    }

    emit(state.copyWith(isNavigationVisible: false));
  }
}
