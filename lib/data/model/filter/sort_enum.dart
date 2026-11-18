import '../../../i18n/i18n.dart';
import '../../exception/exception.dart';
import 'filter_list.dart';
import 'filter_option_model.dart';

enum Sort {
  byNew('rating'),
  byBest('date');

  const Sort(this.value);

  String get label => switch (this) {
    Sort.byNew => t.sort.newest,
    Sort.byBest => t.sort.best,
  };
  final String value;

  List<FilterOption> get filters => switch (this) {
    Sort.byNew => FilterList.scoreOptions,
    Sort.byBest => FilterList.dateOptions,
  };

  factory Sort.fromString(String value) {
    return Sort.values.firstWhere(
      (element) => element.name == value,
      orElse: () => throw const ValueException(.unknownSort),
    );
  }
}
