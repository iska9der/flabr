enum PeriodEnum {
  daily,
  weekly,
  monthly,
  yearly,
  alltime;

  factory PeriodEnum.fromString(String value) {
    PeriodEnum.values.map((element) {
      if (element.name == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение периода');
  }
}
