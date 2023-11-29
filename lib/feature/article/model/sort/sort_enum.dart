enum SortEnum {
  byNew('Новые', 'rating', 'all'),
  byBest('Лучшие', 'date', 'top');

  const SortEnum(this.label, this.value, this.postValue);

  final String label;
  final String value;
  final String postValue;

  factory SortEnum.fromString(String value) {
    SortEnum.values.map((element) {
      if (element.value == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение сортировки');
  }
}
