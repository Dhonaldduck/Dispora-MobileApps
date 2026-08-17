class NewsModel {
  final String id;
  final String title;
  final String content;
  final String? category;
  final String? thumbnailUrl;
  final DateTime createdAt;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    this.category,
    this.thumbnailUrl,
    required this.createdAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    String? thumb = json['thumbnailUrl'] as String?;
    if (thumb != null && !thumb.startsWith('http')) {
      thumb = 'http://10.0.2.2:3000$thumb';
    }

    return NewsModel(
      id: json['id'].toString(),
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String?,
      thumbnailUrl: thumb,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
