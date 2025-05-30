import '/models/subject.dart';

class Subject {
  final String name;
  final String teacher;
  final String? room;

  Subject({
    required this.name,
    required this.teacher,
    this.room,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
        name: json['name'],
        teacher: json['teacher'],
        room: json['room'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'teacher': teacher,
        'room': room,
      };
}
