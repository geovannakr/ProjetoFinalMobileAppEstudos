import '/models/event.dart';

class Event {
  final String title;
  final DateTime date;
  final String? description;

  Event({
    required this.title,
    required this.date,
    this.description,
  });

  // Para converter de JSON (opcional)
  factory Event.fromJson(Map<String, dynamic> json) => Event(
        title: json['title'],
        date: DateTime.parse(json['date']),
        description: json['description'],
      );

  // Para converter para JSON (opcional)
  Map<String, dynamic> toJson() => {
        'title': title,
        'date': date.toIso8601String(),
        'description': description,
      };
}
