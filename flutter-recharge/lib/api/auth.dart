import 'dart:convert';

import 'package:http/http.dart' as http;

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


  getData(data){
    return data['data'];
  }

  _setHeaders() => {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding' : 'gzip, deflate, br',
  };

}