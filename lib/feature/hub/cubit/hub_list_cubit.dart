import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hub_list_state.dart';

class HubListCubit extends Cubit<HubListState> {
  HubListCubit() : super(HubListInitial());
}
