class Report {
  const Report({
    required this.id,
    required this.fileName,
    required this.url,
    required this.createdAt,
    required this.itemCount,
  });
  final String id;
  final String fileName;
  final String url;
  final DateTime? createdAt;
  final int itemCount;
}
