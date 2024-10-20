import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api.dart';
class ProfileUpdatePage extends StatefulWidget {
  ProfileUpdatePage({super.key});

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  // Controller for the text input field
  final TextEditingController _interestController = TextEditingController();

  // Simulate API call to add interest
  Future<void> _addInterest(String interest) async {
    // Simulate delay for the API call
    await Future.delayed(Duration(seconds: 2));
    // Print the added interest (this is where you'd normally call your API)
    print('Interest added: $interest');
    
    // You can add additional functionality here, such as updating the state
    // or showing a confirmation message to the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Interest "$interest" added')),
    );
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _interestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Profile')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        color: Colors.lightBlue[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 100),
            const Text(
              "Howdy!",
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
            const SizedBox(height: 100),
            
            // Text field for adding a new interest
            TextField(
              controller: _interestController,
              decoration: const InputDecoration(
                labelText: 'Add a new interest',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            const SizedBox(height: 20),
            
            // Button to trigger adding the interest
            ElevatedButton(
              onPressed: () async {
                if (_interestController.text.isNotEmpty) {
                  var refreshToken = await API.currentUserData.read(key: 'refreshToken');
                  var data = {
                    "refreshToken": refreshToken,
                    "newInterest": _interestController.text
                  };

                  try {
                    // Simulate adding interest
                    await API.addInterest(data);

                    // Clear the text field after successful API call
                    _interestController.clear(); 

                    // Show a SnackBar for successful interest addition
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Interest added successfully'),
                        duration: Duration(seconds: 3),  // Snackbar will disappear automatically after 3 seconds
                      ),
                    );
                  } catch (e) {
                    // Handle the error if the API call fails
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add interest: $e'),
                        duration: Duration(seconds: 3),  // Display error message for 3 seconds
                      ),
                    );
                  }
                } else {
                  // Show a warning if the text field is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please enter an interest'),
                      duration: Duration(seconds: 3),  // Snackbar will disappear automatically after 3 seconds
                    ),
                  );
                }
              },
              child: Text('Add Interest'),
            ),
            const SizedBox(height: 20),
            
            // Expanded widget to take up remaining space
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Add your new interest above!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
