import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class PerformanceScreen extends StatelessWidget {
  final List<SubjectPerformance> data = [
    SubjectPerformance('Matemática', 7.5),
    SubjectPerformance('Física', 8.0),
    SubjectPerformance('Português', 6.2),
    SubjectPerformance('História', 9.0),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<SubjectPerformance, String>> series = [
      charts.Series(
        id: "Notas",
        data: data,
        domainFn: (SubjectPerformance performance, _) => performance.subject,
        measureFn: (SubjectPerformance performance, _) => performance.average,
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        labelAccessorFn: (SubjectPerformance performance, _) =>
            performance.average.toStringAsFixed(1),
      )
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Desempenho')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Média por matéria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 300, child: charts.BarChart(series, animate: true, barRendererDecorator: charts.BarLabelDecorator<String>(), domainAxis: charts.OrdinalAxisSpec())),
            SizedBox(height: 20),
            _buildAlerts(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlerts() {
    //  alerta para notas abaixo de 7
    List<SubjectPerformance> lowScores = data.where((p) => p.average < 7).toList();

    if (lowScores.isEmpty) {
      return Text('Nenhum alerta de baixo desempenho', style: TextStyle(color: Colors.green));
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lowScores
            .map((e) => Text('Atenção: Desempenho baixo em ${e.subject} (média: ${e.average.toStringAsFixed(1)})',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)))
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
