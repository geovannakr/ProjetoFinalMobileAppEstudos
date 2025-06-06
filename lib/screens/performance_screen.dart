import 'package:flutter/material.dart';

class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({Key? key}) : super(key: key);

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  final Map<String, List<double>> _notasPorMateria = {
    'Matemática': [7.5],
    'Física': [8.0],
    'Português': [6.2],
    'História': [9.0],
  };

  void _adicionarNota() {
    final materiaController = TextEditingController();
    final notaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF203A43),
          title: const Text(
            'Adicionar Nota',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: materiaController,
                decoration: const InputDecoration(
                  labelText: 'Matéria',
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: notaController,
                decoration: const InputDecoration(
                  labelText: 'Nota',
                  labelStyle: TextStyle(color: Colors.lightBlueAccent),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.lightBlueAccent),
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                String materia = materiaController.text.trim();
                double? nota = double.tryParse(notaController.text);

                if (materia.isEmpty || nota == null) {
                  Navigator.pop(context);
                  return;
                }

                setState(() {
                  if (_notasPorMateria.containsKey(materia)) {
                    _notasPorMateria[materia]!.add(nota);
                  } else {
                    _notasPorMateria[materia] = [nota];
                  }
                });

                Navigator.pop(context);
              },
              child: const Text(
                'Salvar',
                style: TextStyle(color: Colors.lightBlueAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  double _media(List<double> notas) {
    if (notas.isEmpty) return 0;
    return notas.reduce((a, b) => a + b) / notas.length;
  }

  @override
  Widget build(BuildContext context) {
    final desempenho = _notasPorMateria.entries.map((entry) {
      return SubjectPerformance(entry.key, _media(entry.value));
    }).toList();

    final baixoDesempenho = desempenho.where((e) => e.average < 7).toList();

    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Desempenho',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Média por matéria',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: desempenho.length,
                    itemBuilder: (context, index) {
                      final perf = desempenho[index];
                      final isBaixo = perf.average < 7;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          title: Text(
                            perf.subject,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Text(
                            perf.average.toStringAsFixed(1),
                            style: TextStyle(
                              color: isBaixo ? Colors.redAccent : Colors.lightBlueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _adicionarNota,
                    icon: const Icon(Icons.add_task),
                    label: const Text('Adicionar Nota'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E88E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Alertas',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                baixoDesempenho.isEmpty
                    ? Text(
                        'Nenhum alerta de baixo desempenho',
                        style: TextStyle(
                          color: Colors.lightBlueAccent.withOpacity(0.8),
                          fontSize: 16,
                        ),
                      )
                    : SizedBox(
                        height: size.height * 0.1,
                        child: ListView(
                          children: baixoDesempenho
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '⚠ Baixo desempenho em ${e.subject} (média: ${e.average.toStringAsFixed(1)})',
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubjectPerformance {
  final String subject;
  final double average;

  SubjectPerformance(this.subject, this.average);
}
