class AgendaModel {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String? category;
  final String? organizer;
  final String? thumbnailUrl;

  AgendaModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.category,
    this.organizer,
    this.thumbnailUrl,
  });

  factory AgendaModel.fromJson(Map<String, dynamic> json) {
    String? thumb = json['thumbnailUrl'] as String?;
    if (thumb != null && !thumb.startsWith('http')) {
      thumb = 'http://10.0.2.2:3000$thumb';
    }

    return AgendaModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startDate: json['startDate'] != null 
          ? DateTime.parse(json['startDate'] as String) 
          : DateTime.now(),
      endDate: json['endDate'] != null 
          ? DateTime.parse(json['endDate'] as String) 
          : DateTime.now(),
      category: json['category'] as String?,
      organizer: json['organizer'] as String?,
      thumbnailUrl: thumb,
    );
  }
}
