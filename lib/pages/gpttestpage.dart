import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/gpt_api.dart';  // Import the service class

class GPTChatScreen extends StatefulWidget {
  @override
  _GPTChatScreenState createState() => _GPTChatScreenState();
}

class _GPTChatScreenState extends State<GPTChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  final OpenAIService openAIService = OpenAIService();

  Future<void> _getGPTResponse() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await openAIService.getCompletion(_controller.text);
      setState(() {
        _response = response;
      });
    } catch (error) {
      setState(() {
        _response = 'Error: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
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
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter your prompt'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getGPTResponse,
              child: _isLoading ? CircularProgressIndicator() : Text('Get Response'),
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
