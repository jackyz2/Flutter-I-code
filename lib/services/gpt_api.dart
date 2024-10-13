import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey = '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';
  Future<String> getCompletion(String prompt) async { 
    final url = Uri.parse('https://api.openai.com/v1/completions');
    final response = await http.post( 
      url,
      headers: { 
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',  // or use 'gpt-3.5-turbo', 'gpt-4' for chat models
        'prompt': prompt,
        'max_tokens': 50,  // Limit the response length
        'temperature': 0.7  // Adjust creativity level
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['text'].trim();  // Get the text completion
    } else {
      throw Exception('Failed to fetch completion: ${response.body}');
    }
  }
}