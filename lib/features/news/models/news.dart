class News {
  final String id;
  final String title;
  final String content;
  final String? thumbnailUrl;
  final String slug;
  final DateTime createdAt;

  News({
    required this.id,
    required this.title,
    required this.content,
    this.thumbnailUrl,
    required this.slug,
    required this.createdAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      slug: json['slug'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
