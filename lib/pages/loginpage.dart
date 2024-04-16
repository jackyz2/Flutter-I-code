import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/profilepage.dart';
import 'registerpage.dart';
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_application_1/main.dart';

class LoginPage extends StatelessWidget {

  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
Future<void> attemptLogin(context) async {
  var data = { 
    "email": emailController.text,
    "password": passwordController.text,
  };
  var isValid = await API.login(data); // Assuming this should also be awaited
  
  if (isValid) {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => MyHomePage(title: "home")),
      (route) => false
    );
  } else {
    // Handle failed validation
  }
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //padding: EdgeInsets.symmetric(vertical: 30),
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
                  Text("Login",
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
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
                                      bottom:
                                          BorderSide(color: Colors.blueGrey))),
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
                              decoration: const BoxDecoration(
                                  //border: Border(bottom: BorderSide(color: Colors.blueGrey))
                                  ),
                              child: TextField(
                                obscureText: true,
                                controller: passwordController,
                                decoration: const InputDecoration(
                                  hintText: "  Password",
                                  hintStyle:
                                      TextStyle(color: Colors.grey, height: 2),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
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
                                builder: (context) => RegisterPage()),
                          );
                        },
                        child: const Center(
                          child: Text(
                            "Click here to register",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          //signUserIn();
                          attemptLogin(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.lightBlue[200],
                          ),
                          child: const Center(
                            child: Text(
                              "Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      /*GestureDetector(
                        onTap: () {
                          //signUserInMSFT();
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.lightBlue[200],
                          ),
                          child: const Center(
                            child: Text(
                              "Microsoft Login",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),*/
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