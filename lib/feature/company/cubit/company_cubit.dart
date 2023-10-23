import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/exception/displayable_exception.dart';
import '../../../component/localization/language_enum.dart';
import '../../settings/repository/language_repository.dart';
import '../model/card/company_card_model.dart';
import '../model/company_model.dart';
import '../repository/company_repository.dart';

part 'company_state.dart';

class CompanyCubit extends Cubit<CompanyState> {
  CompanyCubit(
    String alias, {
    required CompanyRepository repository,
    required LanguageRepository languageRepository,
  })  : _repository = repository,
        _languageRepository = languageRepository,
        super(CompanyState(alias: alias));

  final CompanyRepository _repository;
  final LanguageRepository _languageRepository;

  void fetchCard() async {
    CompanyCardModel card = state.card;

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
    } on DisplayableException catch (e) {
      emit(state.copyWith(
        status: CompanyStatus.failure,
        error: e.toString(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CompanyStatus.failure,
        error: 'Не удалось получить профиль компании',
      ));
    }
  }
}
