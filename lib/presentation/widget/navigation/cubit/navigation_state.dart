// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'navigation_cubit.dart';

class NavigationState with EquatableMixin {
  const NavigationState({
    this.isNavigationVisible = true,
  });

  final bool isNavigationVisible;

  NavigationState copyWith({
    bool? isNavigationVisible,
  }) {
    return NavigationState(
      isNavigationVisible: isNavigationVisible ?? this.isNavigationVisible,
    );
  }

  @override
  List<Object?> get props => [isNavigationVisible];
}
