abstract class ListResponse {
  final int pagesCount;
  final List<String> ids;
  final List refs;

  const ListResponse({
    this.pagesCount = 1,
    this.ids = const [],
    this.refs = const [],
  });
}
