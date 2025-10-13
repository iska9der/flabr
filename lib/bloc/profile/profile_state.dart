part of 'profile_bloc.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(UserMe.empty) UserMe me,
    @Default(UserUpdates.empty) UserUpdates updates,
  }) = _ProfileState;
}
