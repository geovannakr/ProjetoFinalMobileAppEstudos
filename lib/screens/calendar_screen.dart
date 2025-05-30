import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}


class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();


  // Mapa que guarda eventos por data
  final Map<DateTime, List<String>> _events = {
    DateTime(2025, 5, 22): ['Estudar Matemática', 'Prova de História'],
    DateTime(2025, 5, 23): ['Revisão Física'],
  };


  // Função para pegar eventos do dia selecionado
  List<String> _getEventsForDay(DateTime day) {
    // Normaliza a data para ignorar horas, minutos etc.
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }


  @override
  Widget build(BuildContext context) {
    final eventsForSelectedDay = _getEventsForDay(_selectedDay);


    return Scaffold(
      appBar: AppBar(title: Text('Calendário')),
      body: Column(
        children: [
          TableCalendar<String>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: eventsForSelectedDay.map((event) {
                return ListTile(
                  leading: Icon(Icons.event_note),
                  title: Text(event),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}