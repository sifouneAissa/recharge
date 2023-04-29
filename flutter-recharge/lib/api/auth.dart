import 'dart:convert';

import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:async/async.dart';
import 'package:dio/dio.dart';



class AuthApi{

  // final String _url = 'https://recharge-web.afandena-cards.com/api/';
  final String _url = 'http://192.168.1.6/api/';

  getUrl(eurl){
    return _url + eurl;
  }

  login(data) async {

      var fullUrl = _url + 'login';

      print(Uri.parse(fullUrl));
      return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeaders());
  }

  register(data) async {

      var token_firebase =  await GetData().getFirebaseToken();

      var fullUrl = _url + 'register';
      
      data['token_firebase'] = token_firebase;

      return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeaders());
  }

  getUser() async {
    
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();


      var fullUrl = _url + 'user/'+auth['id'].toString();

      return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 
  }

  
  update(data) async {
      print(data);
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'user/'+auth['id'].toString();

     return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeadersAuthorization(token));
 
  }



  addToken(data) async {

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();


      var fullUrl = _url + 'transactions/'+auth['id'].toString();

     return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeadersAuthorization(token));
 
  }

  getTokenPackages() async {

    
      var auth = await GetData().getAuth();
      var token = await GetData().getToken(); 

      
      var fullUrl = _url + 'package/token/'+auth['id'].toString();     

      return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 

  }

  
  getPointPackages() async {

    
      var auth = await GetData().getAuth();
      var token = await GetData().getToken(); 

      
      var fullUrl = _url + 'package/point/'+auth['id'].toString();     

      return await http.get(Uri.parse(fullUrl),headers: _setHeadersAuthorization(token));
 

  }

  

  addPointWithoutP(data) async{
      
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();


      var fullUrl = _url + 'transactions/'+auth['id'].toString();

     return await http.post(Uri.parse(fullUrl),body: jsonEncode(data),headers: _setHeadersAuthorization(token));
 
      // var auth = await GetData().getAuth();
      // var token = await GetData().getToken();
      
      
      // FormData formData =  FormData.fromMap({
      //   'count': data['count'],
      //   'cost': data['cost'],
      //   'type': data['type'],
      //   'name_of_player' : data['name_of_player'],
      //   'point_packages' : jsonEncode(data['point_packages'])
      // });

      
      // var fullUrl = _url + 'transactions/'+auth['id'].toString();
      
      
      
      //  Dio dio = Dio();

      //  return await dio.post(fullUrl,
      //  data: formData,
      //  options: Options(headers: _setHeadersAuthorization(token))
      //  );

       
       
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

  updatePhoto(PickedFile? file) async{
      
      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      FormData formData =  FormData.fromMap({
        'file': await MultipartFile.fromFile(file!.path)
      });
      
      var fullUrl = _url + 'user/'+auth['id'].toString();
      
      
      
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

  getRecentTransactions(data) async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'transactions/'+auth['id'].toString();

      Dio dio = Dio();

      return await dio.get(fullUrl,
          data: data,
          options: Options(headers: _setHeadersAuthorization(token))
       );
  }

   getNotifications() async{

      var auth = await GetData().getAuth();
      var token = await GetData().getToken();

      var fullUrl = _url + 'notifications/'+auth['id'].toString();

      print('_url');
      print(_url);

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
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': "*/*",
      'connection': 'keep-alive',
      'Accept-Encoding' : 'gzip, deflate, br',
      'Authorization': 'Bearer $token',
  };

}