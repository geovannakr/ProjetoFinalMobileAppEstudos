import 'package:flutter/material.dart';
import 'package:projeto_final_rotina_estudos/services/openrouter_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String resposta = '';
  bool carregando = false;

  void enviarPergunta() async {
    final pergunta = _controller.text.trim();
    if (pergunta.isEmpty) return;

    setState(() {
      carregando = true;
      resposta = '';
    });

    final respostaIA = await OpenRouterService.getResposta(pergunta);

    setState(() {
      carregando = false;
      resposta = respostaIA;
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SAIM - Chat IA")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Digite sua pergunta...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => enviarPergunta(),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: carregando ? null : enviarPergunta,
              child: const Text("Enviar"),
            ),
            const SizedBox(height: 20),
            if (carregando)
              const CircularProgressIndicator()
            else if (resposta.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    resposta,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}