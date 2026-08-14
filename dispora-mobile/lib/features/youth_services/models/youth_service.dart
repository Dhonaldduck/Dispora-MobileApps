class YouthService {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? registrationLink;
  final String? thumbnailUrl;

  YouthService({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.registrationLink,
    this.thumbnailUrl,
  });

  factory YouthService.fromJson(Map<String, dynamic> json) {
    return YouthService(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      registrationLink: json['registrationLink'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }
}
