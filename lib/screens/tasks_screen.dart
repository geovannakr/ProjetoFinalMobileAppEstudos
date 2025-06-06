import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final ValueNotifier<Map<DateTime, List<String>>> eventNotifier = ValueNotifier({});

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Map<String, dynamic>> _tasks = [];
  List<Map<String, String>> _exams = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  DateTime _normalizeDate(DateTime date) => DateTime(date.year, date.month, date.day);

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final taskStr = prefs.getString('tasks');
    final examStr = prefs.getString('exams');

    _tasks.clear();
    _exams.clear();
    final Map<DateTime, List<String>> loadedEvents = {};

    if (taskStr != null) {
      _tasks = List<Map<String, dynamic>>.from(json.decode(taskStr));
      for (var task in _tasks) {
        final date = _parseDate(task['dueDate']);
        if (date != null) {
          final normalized = _normalizeDate(date);
          loadedEvents[normalized] = [...(loadedEvents[normalized] ?? []), '${task['title']} (${task['subject']})'];
        }
      }
    }

    if (examStr != null) {
      _exams = List<Map<String, String>>.from(json.decode(examStr));
      for (var exam in _exams) {
        final date = _parseDate(exam['date']);
        if (date != null) {
          final normalized = _normalizeDate(date);
          loadedEvents[normalized] = [...(loadedEvents[normalized] ?? []), '${exam['type']} • ${exam['subject']}'];
        }
      }
    }

    eventNotifier.value = loadedEvents;
    setState(() {});
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasks', json.encode(_tasks));
    await prefs.setString('exams', json.encode(_exams));
  }

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      final parts = dateStr.split('/');
      return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
    } catch (_) {
      return null;
    }
  }

  void _addToEventNotifier(String dateStr, String event) {
    final date = _parseDate(dateStr);
    if (date == null) return;
    final normalized = _normalizeDate(date);
    final existing = eventNotifier.value[normalized] ?? [];
    eventNotifier.value = {
      ...eventNotifier.value,
      normalized: [...existing, event],
    };
  }

  void _removeFromEventNotifier(String dateStr, String event) {
    final date = _parseDate(dateStr);
    if (date == null) return;
    final normalized = _normalizeDate(date);
    final updated = List<String>.from(eventNotifier.value[normalized] ?? [])..remove(event);
    if (updated.isEmpty) {
      final newMap = Map<DateTime, List<String>>.from(eventNotifier.value);
      newMap.remove(normalized);
      eventNotifier.value = newMap;
    } else {
      eventNotifier.value = {
        ...eventNotifier.value,
        normalized: updated,
      };
    }
  }

  void _toggleTaskDone(int index, bool? value) {
    setState(() {
      _tasks[index]['done'] = value ?? false;
    });
    _saveData();
  }

  void _removeTask(int index) {
    final task = _tasks[index];
    _removeFromEventNotifier(task['dueDate'], '${task['title']} (${task['subject']})');
    setState(() => _tasks.removeAt(index));
    _saveData();
  }

  void _removeExam(int index) {
    final exam = _exams[index];
    _removeFromEventNotifier(exam['date']!, '${exam['type']} • ${exam['subject']}');
    setState(() => _exams.removeAt(index));
    _saveData();
  }

  void _addTaskOrExam() {
    final titleController = TextEditingController();
    final subjectController = TextEditingController();
    final dateController = TextEditingController();
    final isExamController = ValueNotifier<bool>(false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Nova Tarefa ou Prova',
          style: TextStyle(
            color: Color(0xFF1E88E5),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(titleController, 'Título'),
              _buildTextField(subjectController, 'Matéria'),
              _buildTextField(dateController, 'Data (dd/mm/aaaa)', keyboard: TextInputType.datetime),
              const SizedBox(height: 8),
              ValueListenableBuilder<bool>(
                valueListenable: isExamController,
                builder: (_, isExam, __) => CheckboxListTile(
                  activeColor: const Color(0xFF1E88E5),
                  title: const Text("É uma prova?"),
                  value: isExam,
                  onChanged: (val) => isExamController.value = val ?? false,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              String title = titleController.text.trim();
              String subject = subjectController.text.trim();
              String dateStr = dateController.text.trim();
              bool isExam = isExamController.value;

              final date = _parseDate(dateStr);
              if (title.isEmpty || subject.isEmpty || dateStr.isEmpty || date == null) return;

              setState(() {
                if (isExam) {
                  _exams.add({'subject': subject, 'type': title, 'date': dateStr});
                  _addToEventNotifier(dateStr, '$title • $subject');
                } else {
                  _tasks.add({
                    'title': title,
                    'subject': subject,
                    'dueDate': dateStr,
                    'priority': 'Média',
                    'done': false,
                  });
                  _addToEventNotifier(dateStr, '$title ($subject)');
                }
              });

              _saveData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Adicionado com sucesso!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Salvar',
              style: TextStyle(
                color: Color(0xFF1E88E5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white.withOpacity(0.05),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF1E88E5)),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Tarefas e Provas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Tarefas'),
                const SizedBox(height: 8),
                ..._tasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final task = entry.value;
                  return _buildDismissibleCard(
                    onDismissed: () => _removeTask(index),
                    child: CheckboxListTile(
                      activeColor: const Color(0xFF1E88E5),
                      title: Text(
                        task['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        '${task['subject']} • Entrega: ${task['dueDate']} • Prioridade: ${task['priority']}',
                        style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      ),
                      value: task['done'],
                      onChanged: (val) => _toggleTaskDone(index, val),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                _buildSectionTitle('Provas'),
                const SizedBox(height: 8),
                ..._exams.asMap().entries.map((entry) {
                  final index = entry.key;
                  final exam = entry.value;
                  return _buildDismissibleCard(
                    onDismissed: () => _removeExam(index),
                    child: ListTile(
                      leading: const Icon(Icons.assignment, color: Colors.lightBlueAccent),
                      title: Text(
                        exam['subject']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        '${exam['type']} • Data: ${exam['date']}',
                        style: TextStyle(color: Colors.white.withOpacity(0.75)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskOrExam,
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar',
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildDismissibleCard({required VoidCallback onDismissed, required Widget child}) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: child,
      ),
    );
  }
}
