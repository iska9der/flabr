enum PeriodEnum {
  daily('Сутки'),
  weekly('Неделя'),
  monthly('Месяц'),
  yearly('Год'),
  alltime('Все время');

  const PeriodEnum(this.label);

  final String label;

  factory PeriodEnum.fromString(String value) {
    PeriodEnum.values.map((element) {
      if (element.name == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение периода');
  }

  factory PeriodEnum.fromLabel(String value) {
    PeriodEnum.values.map((element) {
      if (element.label == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение периода');
  }
}
