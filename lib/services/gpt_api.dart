import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
class OpenAIService {
  final String? apiKey = dotenv.env['OPEN_AI_API_KEY'];
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