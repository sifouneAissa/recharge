import 'dart:convert';

import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'package:dio/dio.dart';

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

  addPoint(data,PickedFile? file) async{
      
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();
      FormData formData =  FormData.fromMap({
        'count': data['count'],
        'cost': data['cost'],
        'type': data['type'],
        'file': await MultipartFile.fromFile(file!.path)
      });
      
      var fullUrl = _url + 'transactions/'+auth['id'].toString();
      
      
       Dio dio = Dio();

       return await dio.post(fullUrl,
       data: formData,
       options: Options(headers: _setHeadersAuthorization(token))
       );

  }

  getTransactions() async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'transactions/'+auth['id'].toString();

     return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 
  }

  filterDates(data) async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'transactions/date/'+auth['id'].toString();
        print(fullUrl);
        
       Dio dio = Dio();

      return await dio.get(fullUrl,
          data: data,
          options: Options(headers: _setHeadersAuthorization(token))
       );
 
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
      // 'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding' : 'gzip, deflate, br',
      'Authorization': 'Bearer $token',
  };

   _setHeadersAuthorizationFile(var token) => {
      'Content-Type': 'multipart/form-data; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding' : 'gzip, deflate, br',
      'Authorization': 'Bearer $token'
  };

}