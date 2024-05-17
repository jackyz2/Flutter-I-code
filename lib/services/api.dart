import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_application_1/models/question_model.dart';
class API {
  static const baseUrl = "http://192.168.3.94:2000/api/";
  static var currentUserData = new FlutterSecureStorage();
  static bool containUser = false;

  static Future<bool> validate() async {
    var refreshToken = await currentUserData.read(key: 'refreshToken');
    if(refreshToken != null) {
      var url = Uri.parse("${baseUrl}auth/newactoken");
      var res = await http.post(url, headers: {"Content-Type": "application/json"}, // Set content type as JSON
        body: json.encode({'refreshToken': refreshToken})); // Send token as part of a JSON body);
      if(res.statusCode == 200) {
        await currentUserData.write(key: 'id', value: json.decode(res.body)["id"]);
        await currentUserData.write(key: 'accessToken', value: json.decode(res.body)["accessToken"]);
        await currentUserData.write(key: 'refreshToken', value: json.decode(res.body)["refreshToken"]);
        await currentUserData.write(key: 'level', value: json.decode(res.body)["level"].toString());
        //print(await currentUserData.read(key: "level"));
        containUser = true;
        return true;
      }
      else {
        containUser = false;
        return false;
      }
    }
    else {
      containUser = false;
      return false;
    }
}

static signOut() async {
  var url = Uri.parse("${baseUrl}auth/logout");
  try {
    var refreshToken = await currentUserData.read(key: 'refreshToken');
    var res = await http.post(url, headers: {"Content-Type": "application/json"}, // Set content type as JSON
    body: json.encode({'refreshToken': refreshToken})); // Send token as part of a JSON body);
    if(res.statusCode == 200) {
      containUser = false;
      currentUserData.deleteAll();
    }
    else {
      print("Failed to get response");
    }
  } catch (e) {
    print(e.toString());
  }

}

static signUp(Map data) async {
    var url = Uri.parse("${baseUrl}auth/signup");
    try{ 
      var res = await http.post(url, body: data);
      if(res.statusCode == 200) {
        await currentUserData.write(key: 'id', value: json.decode(res.body)["id"]);
        await currentUserData.write(key: 'accessToken', value: json.decode(res.body)["accessToken"]);
        await currentUserData.write(key: 'refreshToken', value: json.decode(res.body)["refreshToken"]);
        await currentUserData.write(key: 'level', value: json.decode(res.body)["level"].toString());
        containUser = true;
    }
    else {
      print("Failed to get response");
    }
    } catch(e) {
      print(e.toString());
    }
}
  
  static login(Map data) async {
    var url = Uri.parse("${baseUrl}auth/login");
    try{ 
      final res = await http.post(url, body: data);
      if(res.statusCode == 200) {
        await currentUserData.write(key: 'id', value: json.decode(res.body)["id"]);
        await currentUserData.write(key: 'accessToken', value: json.decode(res.body)["accessToken"]);
        await currentUserData.write(key: 'refreshToken', value: json.decode(res.body)["refreshToken"]);
        await currentUserData.write(key: 'level', value: json.decode(res.body)["level"].toString());
        containUser = true;
        print("correct pw, validated");
        return true;
      }
      else {
        print("Wrong password");
        return false;
      }
    } catch(e) {
      print(e.toString());
    }
  }

  static Future<List<Question>> parseQ(Map data) async{ 
    var url = Uri.parse("${baseUrl}/parse/parseq");
    try{ 
      final res = await http.post(url, body:data);
      if(res.statusCode == 200) {
        final List<dynamic> data = json.decode(res.body);
        return data.map((e) => Question.fromMap(Map<String, dynamic>.from(e))).toList();
      }
      return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  static Future<void> updateLevel(Map data) async {
  var url = Uri.parse("${baseUrl}/parse/updatelevel");
  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(data),
    );
    if (response.statusCode != 200) {
      print("Failed to update level. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
    } else {
      print("Level updated successfully!");
    }
  } catch (e) {
    print("Error updating level: ${e.toString()}");
  }
}

  static Future<Image?> parseImage(String id) async {
    var url = Uri.parse("${baseUrl}/image/image/${id}");
    try {
      final response = await http.get(url);
      if(response.statusCode == 200) {
        return Image.memory(response.bodyBytes);
      }
      else {
        print("Unable to parse image");
      }
    } catch (e) { 
      print("Error parsing image: ${e.toString()}");
      
      return null;
    }
  }
}

  