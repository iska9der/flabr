import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/exception/exception.dart';
import '../../../../../data/model/company/company.dart';
import '../../../../../data/model/language/language.dart';
import '../../../../../data/repository/repository.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit(
    String alias, {
    required CompanyRepository repository,
    required LanguageRepository languageRepository,
  }) : _repository = repository,
       _languageRepository = languageRepository,
       super(CompanyState(alias: alias));

  final CompanyRepository _repository;
  final LanguageRepository _languageRepository;

  void fetchCard() async {
    CompanyCard card = state.card;

    try {
      if (card.isEmpty) {
        emit(state.copyWith(status: CompanyStatus.loading));

        card = await _repository.fetchCard(
          state.alias,
          langUI: _languageRepository.ui,
          langArticles: _languageRepository.articles,
        );
      }

      emit(state.copyWith(status: CompanyStatus.success, card: card));
    } on AppException catch (e) {
      emit(state.copyWith(status: CompanyStatus.failure, error: e.toString()));
    } catch (e) {
      emit(
        state.copyWith(
          status: CompanyStatus.failure,
          error: 'Не удалось получить профиль компании',
        ),
      );
    }
  }
}
