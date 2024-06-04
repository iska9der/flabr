enum Sort {
  byNew('Новые', 'rating', 'all'),
  byBest('Лучшие', 'date', 'top');

  const Sort(this.label, this.value, this.postValue);

  final String label;
  final String value;
  final String postValue;

  factory Sort.fromString(String value) {
    Sort.values.map((element) {
      if (element.value == value) {
        return element;
      }
    });

    throw Exception('Неизвестное значение сортировки');
  }
}
