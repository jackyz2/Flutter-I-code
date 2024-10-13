import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api.dart';
import 'profilepage.dart';
import 'loginpage.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = "";

  void registerUser() {
    var data = {
      "email": emailController.text,
      "password": passwordController.text,
    };
    API.signUp(data);
  }

  bool validateInputs() {
    // Check if email contains '@' and password length is greater than 5
    String email = emailController.text;
    String password = passwordController.text;

    if (!email.contains('@')) {
      setState(() {
        errorMessage = "Please enter a valid email address.";
      });
      return false;
    }

    if (password.length <= 5) {
      setState(() {
        errorMessage = "Password must be longer than 5 characters.";
      });
      return false;
    }

    // If everything is valid, clear the error message
    setState(() {
      errorMessage = "";
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue[200],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 100,
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Register",
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0xF479CBDA),
                                blurRadius: 20,
                                offset: Offset(0, 10))
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 60,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.blueGrey))),
                              child: TextField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: "  Email",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, height: 2.0),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              decoration: const BoxDecoration(),
                              child: TextField(
                                obscureText: true,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  hintText: "  Password",
                                  hintStyle: TextStyle(
                                      color: Colors.grey, height: 2),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Display error message if input is invalid
                      if (errorMessage.isNotEmpty)
                        Text(
                          errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        },
                        child: const Center(
                          child: Text(
                            "Already Registered? Login now",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Validate the input before registration
                          if (validateInputs()) {
                            registerUser();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                              (route) => false,
                            );
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.lightBlue[200],
                          ),
                          child: const Center(
                            child: Text(
                              "Register",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
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
