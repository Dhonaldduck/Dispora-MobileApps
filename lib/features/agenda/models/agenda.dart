class Agenda {
  final String id;
  final String title;
  final String description;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final String? thumbnailUrl;

  Agenda({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.startDate,
    required this.endDate,
    this.thumbnailUrl,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      location: json['location'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String?,
    );
  }
}
