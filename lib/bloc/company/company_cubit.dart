import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/exception/exception.dart';
import '../../data/model/company/company.dart';
import '../../data/model/language/language.dart';
import '../../data/repository/repository.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit(String alias, {required CompanyRepository repository})
    : _repository = repository,
      super(CompanyState(alias: alias));

  final CompanyRepository _repository;

  void fetchCard() async {
    CompanyCard card = state.card;

    try {
      if (card.isEmpty) {
        emit(state.copyWith(status: CompanyStatus.loading));

        card = await _repository.fetchCard(state.alias);
      }

      emit(state.copyWith(status: CompanyStatus.success, card: card));
    } catch (error, stackTrace) {
      emit(
        state.copyWith(
          status: CompanyStatus.failure,
          error: error.parseException('Не удалось получить профиль компании'),
        ),
      );

      super.onError(error, stackTrace);
    }
  }
}
