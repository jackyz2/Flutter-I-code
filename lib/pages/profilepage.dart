import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/profilepage.dart';
import 'registerpage.dart';
import 'package:flutter_application_1/services/api.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/pages/authpage.dart';
class ProfilePage extends StatelessWidget {
   ProfilePage({super.key});
void logUserOut(context) async{
  await API.signOut();
  Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(builder: (context) => AuthPage()),
      (route) => false
    );
}
  @override
  Widget build(BuildContext context) {
    return 
    Container(
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
                  Text("Howdy!",
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
                        topRight: Radius.circular(60))
                        
                ),
                child: Padding( 
                  padding: const EdgeInsets.all(20),
                  child: Column( 
                    children: <Widget> [ 
                      GestureDetector(
                        onTap: () {
                          logUserOut(context);
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.red[500],
                          ),
                          child: const Center(
                            child: Text(
                              "Sign out",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ]
                  )
                ),

              ),
            ),
          ],
        ),
      ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}