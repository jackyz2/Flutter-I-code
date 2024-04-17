import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class API {
  static const baseUrl = "http://192.168.40.240:2000/api/";
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

  /*static sessionAuth() async {
    var url = Uri.parse("${baseUrl}/auth/sessionauth");
    try{ 
      final res = await http.post(url, body: currentUserData);
      if(res.statusCode == 200) {
        currentUserData = currentUserData;
        return 1;
      }
      else {
        return 0;
      }
    } catch(e) {
      print(e.toString());
    }
  }*/
}