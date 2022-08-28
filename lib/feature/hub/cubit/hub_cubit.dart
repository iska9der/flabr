import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hub_state.dart';

class HubCubit extends Cubit<HubState> {
  HubCubit() : super(HubInitial());
}
