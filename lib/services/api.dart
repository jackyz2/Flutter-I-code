import 'dart:convert';

import 'package:http/http.dart' as http;
class API {
  static const baseUrl = "http://192.168.40.240:2000/api/";

  static adddata(Map data) async {
    var url = Uri.parse("${baseUrl}/auth/signup");
    
    try{ 
      final res = await http.post(url, body: data);
      if(res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print("Success");
        print(data);
    }
    else {
      print("Failed to get response");
    }
    } catch(e) {
      print(e.toString());
    }
  }
}