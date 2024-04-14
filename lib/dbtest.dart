import 'package:flutter/material.dart';
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
              MaterialPageRoute(builder: (context) => const createScreen())
            );
          }, child: const Text("CREATE")

          ),
          ElevatedButton(onPressed: (){}, child: const Text("READ")),
          ElevatedButton(onPressed: (){}, child: const Text("UPDATE")),
          ElevatedButton(onPressed: (){}, child: const Text("DELETE")),
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
  @override
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
        }, child: const Text("CreateData")),
      ]
    ),
    );
  }
}