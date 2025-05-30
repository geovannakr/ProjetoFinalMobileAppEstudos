import '/models/task.dart';

enum TaskStatus { pending, completed, late }

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskStatus status;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    this.status = TaskStatus.pending,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        description: json['description'],
        dueDate: DateTime.parse(json['dueDate']),
        status: TaskStatus.values.firstWhere(
          (e) => e.toString() == 'TaskStatus.${json['status']}',
          orElse: () => TaskStatus.pending,
        ),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'dueDate': dueDate.toIso8601String(),
        'status': status.name,
      };
}
