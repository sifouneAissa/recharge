import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';

class NotificationDatatable extends StatefulWidget {
  @override
  _NotificationDatatable createState() => _NotificationDatatable();
}

class _NotificationDatatable extends State<NotificationDatatable> {
  var notifications = [];


@override
  void initState() {
    __getNotifications();
    super.initState();
  }

 __getNotifications() async {
    __getOldNotifications();
      var t = await AuthApi().getNotifications();
      var body = jsonDecode(t.body);
      if(body['status'])
      {
        setState(() {
          var data = AuthApi().getData(body);
          notifications = data['notifications'];
          print('notifications');
          print(notifications);
        });

        await GetData().updateNotifications(notifications);

      }

      
  }

  
  __getOldNotifications() async{

    var t = await GetData().getNotification();
    if(t!=null){
      setState(() {
          notifications = jsonDecode(t);
      });
    }
  }
  _getTexts(){
    return List<Padding>.generate(notifications.length, (index) => Padding(
              padding: EdgeInsets.only(right: 10, top: 10, bottom: 5),
              child: Text.rich(
                TextSpan(
                    text: '#'+(notifications.length - index).toString()+ ' ' + S.of(context).transaction_request,
                    children: <InlineSpan>[
                      TextSpan(
                        text: notifications[index]['info']['type']=='token' ? S.of(context).token + ' ' : S.of(context).point + ' ' ,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold,color: Colors.lightGreen),
                      ),
                      TextSpan(
                        text: S.of(context).transaction_value,
                        // style: TextStyle(
                        //     fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: notifications[index]['info']['cost'].toString() + ' ',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,color: Colors.pinkAccent),
                      ),
                      TextSpan(
                        text: S.of(context).day + notifications[index]['date'],
                        // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ]),
                textAlign: TextAlign.start,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ));
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            // scrollDirection: Axis.horizontal,

            child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: _getTexts() 
          )));
  }
}
