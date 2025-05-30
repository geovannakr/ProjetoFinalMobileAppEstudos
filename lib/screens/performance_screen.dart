import 'package:flutter/material.dart';

class PerformanceScreen extends StatelessWidget {
  final List<SubjectPerformance> data = [
    SubjectPerformance('Matemática', 7.5),
    SubjectPerformance('Física', 8.0),
    SubjectPerformance('Português', 6.2),
    SubjectPerformance('História', 9.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Desempenho')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Média por matéria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...data.map((perf) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${perf.subject}: ${perf.average.toStringAsFixed(1)}',
                style: TextStyle(
                  fontSize: 16,
                  color: perf.average < 7 ? Colors.red : Colors.black,
                ),
              ),
            )),
            SizedBox(height: 20),
            _buildAlerts(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlerts() {
    List<SubjectPerformance> lowScores = data.where((p) => p.average < 7).toList();

    if (lowScores.isEmpty) {
      return Text(
        'Nenhum alerta de baixo desempenho',
        style: TextStyle(color: Colors.green),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lowScores
            .map(
              (e) => Text(
                'Atenção: Desempenho baixo em ${e.subject} (média: ${e.average.toStringAsFixed(1)})',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            )
            .toList(),
      );
    }
  }
}

class SubjectPerformance {
  final String subject;
  final double average;

  SubjectPerformance(this.subject, this.average);
}
