import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_application_1/services/api.dart';

class dbtestScreen extends StatefulWidget {
  const dbtestScreen({super.key});

  @override 
  State<dbtestScreen> createState() => _dbtestScreenState();
}

class _dbtestScreenState extends State<dbtestScreen> {
  @override 
  Widget build(BuildContext context) {
    
    return Scaffold( 
      
      appBar: AppBar(),
      body: Column( 
        mainAxisAlignment: MainAxisAlignment.center,
        children: [ 
          
          ElevatedButton(onPressed: (){
            Navigator.push(context, 
              MaterialPageRoute(builder: (context) => createScreen())
            );
          }, child: Text("CREATE")

          ),
          ElevatedButton(onPressed: (){}, child: Text("READ")),
          ElevatedButton(onPressed: (){}, child: Text("UPDATE")),
          ElevatedButton(onPressed: (){}, child: Text("DELETE")),
        ]
      )
    );
  }
}

class createScreen extends StatefulWidget {
  const createScreen({super.key});
  @override 
  State<createScreen> createState() => _createScreenState();
}
class _createScreenState extends State<createScreen> {
  @override 
  final questionController = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(),
    body: Column( 
      children: [ 
        TextField(
          controller: questionController,
        ),
        ElevatedButton(onPressed: (){ 
          var data = { 
            "questionTitle": questionController.text,
          };
          API.adddata(data);
        }, child: Text("CreateData")),
      ]
    ),
    );
  }
}