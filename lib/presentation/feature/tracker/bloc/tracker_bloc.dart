import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../data/model/loading_status_enum.dart';
import '../../../../data/model/tracker/part.dart';
import '../../../../data/repository/part.dart';

part 'tracker_bloc.freezed.dart';
part 'tracker_event.dart';
part 'tracker_state.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  TrackerBloc({required this.repository}) : super(const TrackerState()) {
    on<TrackerLoad>(fetch);
  }

  final TrackerRepository repository;

  FutureOr<void> fetch(
    TrackerLoad event,
    Emitter<TrackerState> emit,
  ) async {}
}
