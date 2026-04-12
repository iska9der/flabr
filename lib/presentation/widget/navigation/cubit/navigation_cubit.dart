import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void show() {
    emit(state.copyWith(isNavigationVisible: true));
  }

  void hide() {
    emit(state.copyWith(isNavigationVisible: false));
  }
}
