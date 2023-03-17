import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class GetData {
    
    getAuth() async {
        var storage = await getInstance();
        return jsonDecode(storage.getString('user'));
    }

  getToken() async {
        var storage = await getInstance();
        return storage.getString('token');
    }

  getTransaction() async {
        var storage = await getInstance();
        return storage.getString('transactions');
    }

  getNotification() async {
        var storage = await getInstance();
        return storage.getString('notifications');
    }

  getOTransaction() async {
        var storage = await getInstance();
        return storage.getString('transactions');
    }

  getInstance() async{
    
      SharedPreferences localeStorage = await SharedPreferences.getInstance();
      // save the token
      
      return localeStorage;
  }

  logout() async{
    
        SharedPreferences storage = await getInstance();
        storage.remove('user');
        storage.remove('token');
  }
}


