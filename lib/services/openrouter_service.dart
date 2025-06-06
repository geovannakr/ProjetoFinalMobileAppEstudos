import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenRouterService {
  static const String _apiKey = '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';
  static const String _url = 'https://openrouter.ai/api/v1/chat/completions';

  static Future<String> getResposta(String pergunta) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'HTTP-Referer': 'https://seuapp.com',
          'X-Title': 'SeuAppFlutter',
        },
        body: jsonEncode({
          "model": "openai/gpt-3.5-turbo", 
          "messages": [
            {"role": "user", "content": pergunta}
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final resposta = data['choices'][0]['message']['content'];
        return resposta.trim();
      } else {
        return "Erro ${response.statusCode}: ${response.body}";
      }
    } catch (e) {
      return "Erro: $e";
    }
  }
}