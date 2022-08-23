enum SortEnum {
  byNew('Новые', 'rating'),
  byBest('Лучшие', 'date');

  const SortEnum(this.label, this.value);

  final String label;
  final String value;

  factory SortEnum.fromString(String value) {
    SortEnum.values.map((element) {
      if (element.value == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение сортировки');
  }
}
