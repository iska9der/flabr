import 'filter_list.dart';
import 'filter_option_model.dart';

enum Sort {
  byNew('Новые', 'rating', 'all'),
  byBest('Лучшие', 'date', 'top');

  const Sort(this.label, this.value, this.postValue);

  final String label;
  final String value;
  final String postValue;

  List<FilterOption> get filters => switch (this) {
    Sort.byNew => FilterList.scoreOptions,
    Sort.byBest => FilterList.dateOptions,
  };

  factory Sort.fromString(String value) {
    return Sort.values.firstWhere(
      (element) => element.name == value,
      orElse: () => throw Exception('Неизвестное значение сортировки'),
    );
  }
}
