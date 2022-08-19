enum SortEnum {
  rating('Новые'),
  date('Лучшие');

  const SortEnum(this.label);

  final String label;

  factory SortEnum.fromString(String value) {
    SortEnum.values.map((element) {
      if (element.name == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение сортировки');
  }
}
