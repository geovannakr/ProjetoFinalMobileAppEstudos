import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> _tasks = [
    {
      'title': 'Estudar História',
      'subject': 'História',
      'dueDate': '29/05',
      'priority': 'Alta',
      'done': false,
    },
    {
      'title': 'Exercícios de Matemática',
      'subject': 'Matemática',
      'dueDate': '30/05',
      'priority': 'Média',
      'done': false,
    },
  ];

  List<Map<String, String>> _exams = [
    {
      'subject': 'Português',
      'type': 'Prova',
      'date': '31/05',
    },
    {
      'subject': 'Biologia',
      'type': 'Simulado',
      'date': '03/06',
    },
  ];

  void _toggleTaskDone(int index, bool? value) {
    setState(() {
      _tasks[index]['done'] = value ?? false;
    });
  }

  void _addTaskOrExam() {
    // Aqui você pode abrir um modal futuramente para adicionar tarefas ou provas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tarefas e Provas')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Tarefas', style: Theme.of(context).textTheme.titleLarge),
            ..._tasks.map((task) {
              int index = _tasks.indexOf(task);
              return Card(
                child: CheckboxListTile(
                  title: Text(task['title']),
                  subtitle: Text(
                      '${task['subject']} • Entrega: ${task['dueDate']} • Prioridade: ${task['priority']}'),
                  value: task['done'],
                  onChanged: (value) => _toggleTaskDone(index, value),
                ),
              );
            }).toList(),
            SizedBox(height: 24),
            Text('Provas', style: Theme.of(context).textTheme.titleLarge),
            ..._exams.map((exam) {
              return Card(
                child: ListTile(
                  leading: Icon(Icons.assignment),
                  title: Text('${exam['subject']}'),
                  subtitle: Text('${exam['type']} • Data: ${exam['date']}'),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskOrExam,
        child: Icon(Icons.add),
        tooltip: 'Adicionar tarefa ou prova',
      ),
    );
  }
}
