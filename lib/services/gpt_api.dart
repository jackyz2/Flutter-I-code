import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
Future<List<Question>> fetchQuizQuestions() async {
  var refreshToken = await API.currentUserData.read(key: 'refreshToken');
  var data = {"refreshToken": refreshToken};
  return API.parseQ(data);
}
*/

class OpenAIService {
  final String? apiKey = dotenv.env['OPEN_AI_API_KEY'];
  Future<Map<String, dynamic>> generateQuestion({ 
    required int userLevel, //user level
    required String interest, //the user might have multiple interests, and this interest can be randomly selected from the database
  }) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {
            'role': 'system',
            'content': 'You are an assistant that generates programming quiz questions.'
          },
          {
            'role': 'user',
            'content': '''
Generate a multiple-choice question for a user with a $userLevel level in programming. The question should be about $interest. Return the result in the following JSON format:

{
  "_id": {"oid": "generated_id"},
  "questionTitle": "Generated question title",
  "imageUrl": "",
  "category": "0",
  "options": [
    "A) Option 1",
    "B) Option 2",
    "C) Option 3",
    "D) Option 4"
  ],
  "answer": "Correct answer",
  "isTree": false
}
'''
          }
        ],
        'max_tokens': 500,  // Set appropriate token limit
        'temperature': 0.7  // Adjust creativity level
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final generatedQuestion = data['choices'][0]['message']['content'];
      return jsonDecode(generatedQuestion);  // Return parsed JSON object
    } else {
      throw Exception('Failed to generate question: ${response.body}');
    }
  }
  



  Future<String> getCompletion(String prompt) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');  // Updated endpoint
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',  // or use 'gpt-3.5-turbo', 'gpt-4' for chat models
        'messages': [
          {
            'role': 'user',  // Role of the message
            'content': prompt  // The prompt goes here
          }
        ],
        'max_tokens': 50,  // Limit the response length
        'temperature': 0.7  // Adjust creativity level
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();  // Get the chat completion
    } else {
      throw Exception('Failed to fetch completion: ${response.body}');
    }
  }
}
