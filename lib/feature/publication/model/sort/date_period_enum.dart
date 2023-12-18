enum DatePeriodEnum {
  daily('Сутки'),
  weekly('Неделя'),
  monthly('Месяц'),
  yearly('Год'),
  alltime('Все время');

  const DatePeriodEnum(this.label);

  final String label;

  factory DatePeriodEnum.fromString(String value) {
    DatePeriodEnum.values.map((element) {
      if (element.name == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение периода');
  }

  factory DatePeriodEnum.fromLabel(String value) {
    DatePeriodEnum.values.map((element) {
      if (element.label == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение периода');
  }
}
