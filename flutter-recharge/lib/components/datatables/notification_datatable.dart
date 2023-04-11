import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';

class NotificationDatatable extends StatefulWidget {
  final ScrollController? parentScrollController;

  const NotificationDatatable({Key? key, this.parentScrollController}) : super(key: key);

  @override
  _NotificationDatatable createState() => _NotificationDatatable();
}

class _NotificationDatatable extends State<NotificationDatatable> {
  var notifications = [];
  var diffs = [];

  @override
  void initState() {
    __getNotifications();
    super.initState();
    
    widget.parentScrollController?.addListener(() async {
      if (widget.parentScrollController?.position.pixels == widget.parentScrollController?.position.minScrollExtent) {
          await __getNotifications();
       }
      });
  }

  __getNotifications() async {
    __getOldNotifications();
    var t = await AuthApi().getNotifications();
    var body = jsonDecode(t.body);

    if (body['status']) {
      setState(() {
        var data = AuthApi().getData(body);
        notifications = data['notifications'];
        diffs = data['diffs'];
      });

      await GetData().updateNotifications(notifications);
      await GetData().updateDiffs(diffs);
    }
  }

  __getOldNotifications() async {
    var t = await GetData().getNotification();
    var d = await GetData().getDiffs();
    
    if (t != null) {
    
      setState(() {
        notifications = jsonDecode(t);
        diffs = jsonDecode(d);
      });
    }
  }

  _getColumns() {
    return List<Column>.generate(
        diffs.length,
        (index) => Column(

                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Text(
                      diffs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                      
                    ),
                  ),
                  Column(
                    children: _getSubContainer(notifications[index]),
                  )
                ]));
  }

  _getSubContainer(notifications) {

    return List<Container>.generate(
        notifications.length,
        (index) => Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: FitnessAppTheme.nearlyDarkBlue)
                  ),
              child: Row(
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 10,left: 10,top: 10),

                      child: Container(
                          decoration: BoxDecoration(

                          borderRadius: BorderRadius.all(Radius.circular(60)),
                          border: Border.all(color: FitnessAppTheme.nearlyDarkBlue)
                          ),
                          // color: FitnessAppTheme.nearlyDarkBlue, // Button color
                          // shadowColor: FitnessAppTheme.nearlyDarkBlue,
                          
                          child: InkWell(
                            splashColor: null, // Splash color
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset('assets/fitness_app/tab_4s.png',width: 40,)
                                ),
                            )
                          ),
                        )),
                  Flexible(child: _getTexts(notifications[index])),
                ],
              ),
            ));
  }

  _getTexts(notification) {
    bool isTorP = notification['info']['type'] == 'token' || notification['info']['type'] == 'point';
    if(isTorP)
    return Text.rich(
      notification['data']['action'] == null ? TextSpan(
          text: S.of(context).transaction_request,
          children: <InlineSpan>[
            TextSpan(
              text: notification['info']['type'] == 'token'
                  ? S.of(context).token + ' '
                  : S.of(context).point + ' ',
              style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.lightGreen
                  ),
            ),
            TextSpan(
              text: S.of(context).transaction_value,
              // style: TextStyle(
              //     fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: Common.formatNumber(notification['info']['count'])  + ' ',
              style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.pinkAccent
                  ),
            ),
            TextSpan(
              text: S.of(context).day + notification['date'],
              // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ]) : (
              notification['data']['action'] =='accepted' ? 
              TextSpan(
          text: 'لقد تم قبول طلبك المتعلق ب',
          children: <InlineSpan>[
            TextSpan(
              text: notification['info']['type'] == 'token'
                  ? S.of(context).token + ' '
                  : S.of(context).point + ' ',
              style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.lightGreen
                  ),
            ),
            TextSpan(
              text: S.of(context).transaction_value,
              // style: TextStyle(
              //     fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: Common.formatNumber(notification['info']['count']) + ' ',
              style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.pinkAccent
                  ),
            ),
            TextSpan(
              text: S.of(context).day + notification['date'],
              // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ])
          : TextSpan(
          text: 'لقد تم رفض طلبك المتعلق ب',
          children: <InlineSpan>[
            TextSpan(
              text: notification['info']['type'] == 'token'
                  ? S.of(context).token + ' '
                  : S.of(context).point + ' ',
              style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.lightGreen
                  ),
            ),
            TextSpan(
              text: S.of(context).transaction_value,
              // style: TextStyle(
              //     fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: Common.formatNumber(notification['info']['count']) + ' ',
              style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.pinkAccent
                  ),
            ),
            TextSpan(
              text: S.of(context).day + notification['date'],
              // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ])
          ),
      textAlign: TextAlign.start,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
    else
    return Text.rich(
      TextSpan(
          text: 'لقد تم اضافة رصيد  ',
          children: <InlineSpan>[
            TextSpan(
              text: S.of(context).transaction_value,
              // style: TextStyle(
              //     fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: Common.formatNumber(notification['info']['cost']) + ' ',
              style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.pinkAccent
                  ),
            ),
            TextSpan(
              text: ' الى رصيدك ',
              style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.bold,
                  // color: Colors.lightGreen
                  ),
            ),
            TextSpan(
              text: S.of(context).day + notification['date'],
              // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
            ),
      ]),
      textAlign: TextAlign.start,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            // scrollDirection: Axis.horizontal,
            child: Column(
          children: _getColumns(),
        )));
  }
}
