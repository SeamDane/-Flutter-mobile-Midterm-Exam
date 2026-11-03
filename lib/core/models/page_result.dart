class PageResult<T> {
  const PageResult({required this.items, required this.total});
  final List<T> items;
  final int total;
}
