import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, this.userName = 'Isabeli'});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumo do Dia'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Matérias'),
              onTap: () => Navigator.pushNamed(context, '/subjects'),
            ),
            ListTile(
              leading: Icon(Icons.calendar_month),
              title: Text('Calendário'),
              onTap: () => Navigator.pushNamed(context, '/calendar'),
            ),
            ListTile(
              leading: Icon(Icons.task),
              title: Text('Tarefas e Provas'),
              onTap: () => Navigator.pushNamed(context, '/tasks'),
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Desempenho'),
              onTap: () => Navigator.pushNamed(context, '/performance'),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Bom dia, $userName!",
                style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 24),
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.class_),
                title: Text("Aulas do Dia"),
                subtitle: Text("Matemática - 10h\nHistória - 13h"),
              ),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 3,
              child: ListTile(
                leading: Icon(Icons.check_box),
                title: Text("Tarefas Pendentes"),
                subtitle: Text("Estudar capítulo 5 de História\nResolver exercícios de Matemática"),
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/tasks'),
                  icon: Icon(Icons.add),
                  label: Text("Adicionar Tarefa"),
                ),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/calendar'),
                  icon: Icon(Icons.calendar_today),
                  label: Text("Ver Calendário"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
