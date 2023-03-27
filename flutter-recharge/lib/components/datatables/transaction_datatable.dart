import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/constants.dart';
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
  var stransactions = [];

    List<String> columns = [
      '#',
      S().count,
      S().cost_d,
      'اسم اللاعب',
      'معرف اللاعب',
      S().transaction_type,
      'الحالة',
      S().date
    ];
    TextEditingController search =  TextEditingController();
    

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
          stransactions = data['transactions'];
        });

        await GetData().updateTransactions(transactions);

      }

      
  }


  __getOldTransactions() async{
    var t = await GetData().getTransaction();
    if(t!=null){
      setState(() {
          transactions = jsonDecode(t);
          stransactions = transactions;

      });
    }
  }

  
  @override
  void initState() {
     animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    
    __getTransactions();
    super.initState();
    
  search.addListener(() {
      if(search.value.text.isNotEmpty){
          var t = transactions.where((element) => element['account_id'].toString().contains(search.value.text) || element['name_of_player'].toString().contains(search.value.text)).toList();

          setState(() {
              stransactions = t;
          });
      }
      else 
      setState(() {
          stransactions = transactions;
      });
  });
  }


  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }


  transactionStatus(transaction) {
    String text = '';
    if(transaction['waiting'])
        text = 'يتم مراجعة الطلب';
    else if(transaction['accepted'])
        text = 'تم قبول الطلب';
    else if(transaction['rejected'])
        text = 'تم رفض طلبك';
        
    return Text(text,
        style: TextStyle(fontWeight: FontWeight.bold));
        
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {

       return Column(
        children: [
          TextFormField(
            controller: search,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            textDirection: TextDirection.rtl,
            onSaved: (email) {},
            decoration: InputDecoration(
              hintText: 'بحث عن طريق الاسم او معرف الحساب',
              hintStyle : TextStyle(
                  color: Colors.black
                ),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(defaultPadding),
                child: Icon(Icons.search,color:FitnessAppTheme.nearlyDarkBlue),
              ),
            ),
          ),
          SingleChildScrollView(
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
              ))), rows: List<DataRow>.generate(stransactions.length,(counter) => 
                  DataRow(cells: [
                    DataCell(Text('#' + transactions[counter]['id'].toString(),style: TextStyle(color: FitnessAppTheme.nearlyDarkBlue,fontWeight: FontWeight.bold),)),
                    DataCell(Text(stransactions[counter]['count'].toString(),style: TextStyle(fontWeight: FontWeight.bold),)),
                    DataCell(Text(stransactions[counter]['cost'].toString(),style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(stransactions[counter]['name_of_player']!=null ? stransactions[counter]['name_of_player'].toString() : '',style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text(stransactions[counter]['account_id']!=null ? stransactions[counter]['account_id'].toString() : '',style: TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(stransactions[counter]['type'].toString() == 'token' ? Image.asset('assets/fitness_app/tab_3s.png',width: 40,) : Image.asset('assets/fitness_app/tab_2s.png',width: 40,)),
                    DataCell(transactionStatus(stransactions[counter])),
                    DataCell(Text(stransactions[counter]['tdate'].toString(),style: TextStyle(fontWeight: FontWeight.bold,color: FitnessAppTheme.nearlyDarkBlue)))
                  ],
                  // color: transactions[counter]['type'].toString() == 'token' ? MaterialStateProperty.all(Colors.lightGreen) : MaterialStateProperty.all(Colors.pinkAccent)
                  ),
              ))))
        ],
       );

      });
  }
}
