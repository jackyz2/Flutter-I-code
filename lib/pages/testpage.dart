import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/services/api.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageLoaderPage(),
    );
  }
}

class ImageLoaderPage extends StatefulWidget {
  @override
  _ImageLoaderPageState createState() => _ImageLoaderPageState();
}

class _ImageLoaderPageState extends State<ImageLoaderPage> {
  Future<Image?>? imageFuture;

  
  void loadImage() {
    setState(() {
      imageFuture = API.parseImage('66453d04befb95e9004ef94f');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Load Image Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (imageFuture != null)
            Expanded(
              child: FutureBuilder<Image?>(
                future: imageFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Center(
                        child: Container(
                          child: snapshot.data,
                          height: 300,
                          width: 300,
                        ),
                      );
                    } else {
                      return const Center(child: Text('Failed to load image'));
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: loadImage,
            child: Text('Load Image'),
          ),
        ],
      ),
    );
  }
}
