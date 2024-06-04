part of 'part.dart';

extension StateStatusX on Enum {
  bool get isInitial => name == 'initial';
  bool get isLoading => name == 'loading';
  bool get isSuccess => name == 'success';
  bool get isFailure => name == 'failure';
}
