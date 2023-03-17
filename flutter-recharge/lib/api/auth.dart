import 'dart:convert';

import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthApi{

  final String _url = 'http://192.168.1.3:8000/api/';


  login(data) async {

      var fullUrl = _url + 'login';
      print(Uri.parse(fullUrl));
      return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeaders());
  }

  register(data) async {

      var fullUrl = _url + 'register';
      print(Uri.parse(fullUrl));
      return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeaders());
  }

  addToken(data) async {

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      print('Bearer $token');

      var fullUrl = _url + 'transactions/'+auth['id'].toString();

     return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeadersAuthorization(token));
 
  }


  getData(data){
    return data['data'];
  }

  updateUser(data) async{
    
      SharedPreferences storage = await GetData().getInstance();
      storage.setString('user', jsonEncode(data['user']));
  }

  _setHeaders() => {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding' : 'gzip, deflate, br',
  };

  _setHeadersAuthorization(var token) => {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding' : 'gzip, deflate, br',
      'Authorization': 'Bearer $token',
  };

}