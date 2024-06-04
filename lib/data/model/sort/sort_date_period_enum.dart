enum SortDatePeriod {
  daily('Сутки'),
  weekly('Неделя'),
  monthly('Месяц'),
  yearly('Год'),
  alltime('Все время');

  const SortDatePeriod(this.label);

  final String label;

  factory SortDatePeriod.fromString(String value) {
    SortDatePeriod.values.map((element) {
      if (element.name == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение периода');
  }

  factory SortDatePeriod.fromLabel(String value) {
    SortDatePeriod.values.map((element) {
      if (element.label == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение периода');
  }
}
