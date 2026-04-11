part of 'company_cubit.dart';

class CompanyState with EquatableMixin {
  const CompanyState({
    this.status = .initial,
    this.error = '',
    required this.alias,
    this.model = Company.empty,
    this.card = CompanyCard.empty,
  });

  final LoadingStatus status;
  final String error;

  final String alias;
  final Company model;
  final CompanyCard card;

  CompanyState copyWith({
    LoadingStatus? status,
    String? error,
    Language? langUI,
    List<Language>? langArticles,
    Company? model,
    CompanyCard? card,
  }) {
    return CompanyState(
      alias: alias,
      status: status ?? this.status,
      error: error ?? this.error,
      model: model ?? this.model,
      card: card ?? this.card,
    );
  }

  @override
  List<Object> get props => [
    status,
    error,
    alias,
    model,
    card,
  ];
}
