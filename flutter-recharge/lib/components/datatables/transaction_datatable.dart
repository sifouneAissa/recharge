import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
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
      S().cost_d,
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
                    color: Colors.red),
              ))), rows: List<DataRow>.generate(transactions.length,(counter) => 
                  DataRow(cells: [
                    DataCell(Text('#' + transactions[counter]['id'].toString())),
                    DataCell(Text(transactions[counter]['count'].toString())),
                    DataCell(Text(transactions[counter]['cost'].toString())),
                    DataCell(Text(transactions[counter]['type'].toString() == 'token' ? S.of(context).token : S.of(context).point)),
                    DataCell(Text(transactions[counter]['tdate'].toString()))
                  ],color: transactions[counter]['type'].toString() == 'token' ? MaterialStateProperty.all(Colors.amberAccent) : MaterialStateProperty.all(Colors.pinkAccent)),
              ))));

      });
  }
}
