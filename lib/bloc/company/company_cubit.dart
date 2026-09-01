import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/company/company.dart';
import '../../data/model/language/language.dart';
import '../../data/model/loading_status_enum.dart';
import '../../data/repository/repository.dart';
import '../error/app_failure.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit(String alias, {required this._repository})
    : super(CompanyState(alias: alias));

  final CompanyRepository _repository;

  void fetchCard() async {
    CompanyCard card = state.card;

    try {
      if (card.isEmpty) {
        emit(state.copyWith(status: .loading));

        card = await _repository.fetchCard(state.alias);
      }

      emit(state.copyWith(status: .success, card: card));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: .failure,
          error: AppFailure(.companyProfileFetchFailed, error),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
