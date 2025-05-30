import 'package:flutter/material.dart';


class Subject {
  String name;
  IconData icon;


  Subject({required this.name, required this.icon});
}


class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});


  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}


class _SubjectsScreenState extends State<SubjectsScreen> {
  List<Subject> subjects = [
    Subject(name: "Matemática", icon: Icons.calculate),
    Subject(name: "História", icon: Icons.history_edu),
    Subject(name: "Português", icon: Icons.book),
  ];


  void _addSubject() {
    String newName = "";
    IconData newIcon = Icons.book;


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar Matéria"),
          content: TextField(
            decoration: InputDecoration(labelText: "Nome da Matéria"),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (newName.isNotEmpty) {
                  setState(() {
                    subjects.add(Subject(name: newName, icon: newIcon));
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }


  void _editSubject(int index) {
    String editedName = subjects[index].name;


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Editar Matéria"),
          content: TextField(
            decoration: InputDecoration(labelText: "Nome da Matéria"),
            controller: TextEditingController(text: editedName),
            onChanged: (value) {
              editedName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                if (editedName.isNotEmpty) {
                  setState(() {
                    subjects[index].name = editedName;
                  });
                  Navigator.pop(context);
                }
              },
              child: Text("Salvar"),
            ),
          ],
        );
      },
    );
  }


  void _removeSubject(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Remover Matéria"),
          content: Text("Tem certeza que deseja remover ${subjects[index].name}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  subjects.removeAt(index);
                });
                Navigator.pop(context);
              },
              child: Text("Remover"),
            ),
          ],
        );
      },
    );
  }


  void _viewSubjectDetails(Subject subject) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubjectDetailsScreen(subject: subject),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matérias'),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          final subject = subjects[index];
          return ListTile(
            leading: Icon(subject.icon, color: Theme.of(context).primaryColor),
            title: Text(subject.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.orange),
                  onPressed: () => _editSubject(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeSubject(index),
                ),
              ],
            ),
            onTap: () => _viewSubjectDetails(subject),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addSubject,
        child: Icon(Icons.add),
      ),
    );
  }
}


class SubjectDetailsScreen extends StatelessWidget {
  final Subject subject;


  const SubjectDetailsScreen({super.key, required this.subject});


  @override
  Widget build(BuildContext context) {
    // Aqui você pode puxar as tarefas, provas e notas associadas à matéria.
    return Scaffold(
      appBar: AppBar(title: Text(subject.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Tarefas", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text("Nenhuma tarefa cadastrada."), // Placeholder
            SizedBox(height: 16),
            Text("Provas", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text("Nenhuma prova cadastrada."), // Placeholder
            SizedBox(height: 16),
            Text("Notas", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text("Nenhuma nota lançada."), // Placeholder
          ],
        ),
      ),
    );
  }
}


