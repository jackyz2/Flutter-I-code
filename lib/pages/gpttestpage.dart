import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/gpt_api.dart'; // Import the service class
import 'package:flutter_application_1/services/api.dart';
class GPTChatScreen extends StatefulWidget {
  @override
  _GPTChatScreenState createState() => _GPTChatScreenState();
}

class _GPTChatScreenState extends State<GPTChatScreen> {
  String _response =
      ''; // For displaying responses (including userLevel, interest, and question)
  bool _isLoading = false;

  final OpenAIService openAIService = OpenAIService();

  Future<void> _getUserInfoAndGenerateQuestion() async {
    setState(() {
      _isLoading =
          true; // Show a loading spinner while the request is being made
    });
    var refreshToken = await API.currentUserData.read(key: 'refreshToken');
    var data = {"refreshToken": refreshToken};

    try {
      // Step 1: Parse user info to get userLevel and randomInterest
      final userInfo = await API.parseUserInfo(data);
      int userLevel = userInfo['userLevel'];
      String interest = userInfo['interest'];

      // Step 2: Generate a question based on the userLevel and interest
      final question = await openAIService.generateQuestion(
        userLevel: userLevel,
        interest: interest,
      );

      // Update the UI with user info and the generated question
      setState(() {
        _response = '''
User Level: $userLevel
Interest: $interest

Generated Question:
${question['questionTitle']}
Options: ${question['options'].join(', ')}
Answer: ${question['answer']}
        ''';
      });
    } catch (error) {
      setState(() {
        _response = 'Error: $error';
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide the loading spinner
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GPT Chat')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getUserInfoAndGenerateQuestion,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Get User Info and Generate Question'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_response),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
