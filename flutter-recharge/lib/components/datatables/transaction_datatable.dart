import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';

class TransactionDatatable extends StatefulWidget {
  const TransactionDatatable(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _TransactionDatatable createState() => _TransactionDatatable();
}

class _TransactionDatatable extends State<TransactionDatatable> with TickerProviderStateMixin {
  AnimationController? animationController;

  var transactions = [];
    List<String> columns = [
      '#',
      S().count,
      S().cost_d,
      S().transaction_type,
      S().date
    ];

    var testT = [
      {
        'id' : '1',
        'count' : 'count' ,
        'cost' : 'cost',
        'date' : 'date'
      }
    ];

    

  __getTransactions() async {
    __getOldTransactions();
      var t = await AuthApi().getTransactions();
      var body = jsonDecode(t.body);
      if(body['status'])
      {
        setState(() {
          var data = AuthApi().getData(body);
          transactions = data['transactions'];
        });

        await GetData().updateTransactions(transactions);

      }

      
  }


  __getOldTransactions() async{
    var t = await GetData().getTransaction();
    if(t!=null){
      setState(() {
          transactions = jsonDecode(t);
      });
    }
  }

  
  @override
  void initState() {
     animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    
    __getTransactions();
    super.initState();
  }


  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {

       return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
                columns: List<DataColumn>.generate(columns.length,(counter) => DataColumn(
                label: Text(
                columns[counter],
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: FitnessAppTheme.nearlyDarkBlue),
              ))), rows: List<DataRow>.generate(transactions.length,(counter) => 
                  DataRow(cells: [
                    DataCell(Text('#' + transactions[counter]['id'].toString(),style: TextStyle(color: FitnessAppTheme.nearlyDarkBlue,fontWeight: FontWeight.bold),)),
                    DataCell(Text(transactions[counter]['count'].toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataCell(Text(transactions[counter]['cost'].toString(),style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(transactions[counter]['type'].toString() == 'token' ? Icon(Icons.wallet_outlined,color: FitnessAppTheme.nearlyBlue,size: 40,) : Icon(IconData(0xf0654, fontFamily: 'MaterialIcons'),color: Colors.amber, size: 40,)),
                    DataCell(Text(transactions[counter]['tdate'].toString(),style: TextStyle(fontWeight: FontWeight.bold,color: FitnessAppTheme.nearlyDarkBlue)))
                  ],
                  // color: transactions[counter]['type'].toString() == 'token' ? MaterialStateProperty.all(Colors.lightGreen) : MaterialStateProperty.all(Colors.pinkAccent)
                  ),
              ))));

      });
  }
}
