enum SortEnum {
  date('По дням'),
  rating('По рейтингу');

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
