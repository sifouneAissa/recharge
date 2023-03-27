import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

class RecentTokenTransactionDatatable extends StatefulWidget {
  const RecentTokenTransactionDatatable(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;

  @override
  _RecentTokenTransactionDatatable createState() =>
      _RecentTokenTransactionDatatable();
}

class _RecentTokenTransactionDatatable
    extends State<RecentTokenTransactionDatatable>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();

  var transactions = [];
  List<String> columns = ['#', S().count, S().cost_d,'معرف الحساب', 'الحالة', S().date];

  var testT = [
    {'id': '1', 'count': 'count', 'cost': 'cost', 'date': 'date'}
  ];

  __getTransactions() async {
    __getOldTransactions();
    var t = await AuthApi().getTransactions();
    var body = jsonDecode(t.body);
    if (body['status']) {
      setState(() {
        var data = AuthApi().getData(body);
        transactions = data['transactions'];
        transactions = transactions
            .where((element) => element['type'] == 'token')
            .toList()
            .take(5)
            .toList();
      });

      await GetData().updateTransactions(transactions);
    }
  }

  __getOldTransactions() async {
    var t = await GetData().getTransaction();
    if (t != null) {
      setState(() {
        transactions = jsonDecode(t);
        transactions = transactions
            .where((element) => element['type'] == 'token')
            .toList()
            .take(5)
            .toList();
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
          return AdaptiveScrollbar(
            underColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.3),
            sliderDefaultColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.7),
            sliderActiveColor: FitnessAppTheme.nearlyDarkBlue,
            controller: _verticalScrollController,
            child: AdaptiveScrollbar(
                controller: _horizontalScrollController,
                position: ScrollbarPosition.bottom,
                underColor: FitnessAppTheme.nearlyDarkBlue.withOpacity(0.3),
                sliderDefaultColor:
                    FitnessAppTheme.nearlyDarkBlue.withOpacity(0.7),
                sliderActiveColor: FitnessAppTheme.nearlyDarkBlue,
                child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: SingleChildScrollView(
                      controller: _verticalScrollController,
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              showBottomBorder: true,
                              columns: List<DataColumn>.generate(
                                  columns.length,
                                  (counter) => DataColumn(
                                          label: Text(
                                        columns[counter],
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w800,
                                            color:
                                                FitnessAppTheme.nearlyDarkBlue),
                                      ))),
                              rows: List<DataRow>.generate(
                                transactions.length,
                                (counter) => DataRow(
                                  cells: [
                                    DataCell(Text(
                                      '#' +
                                          transactions[counter]['id']
                                              .toString(),
                                      style: TextStyle(
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataCell(Text(
                                      transactions[counter]['count'].toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    )),
                                    DataCell(Text(
                                        transactions[counter]['cost']
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))),
                                    DataCell(Text(transactions[counter]['account_id'].toString())),
                                    DataCell(transactionStatus(transactions[counter])),
                                    DataCell(Text(
                                        transactions[counter]['tdate']
                                            .toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: FitnessAppTheme
                                                .nearlyDarkBlue)))
                                  ],
                                  // color: transactions[counter]['type'].toString() == 'token' ? MaterialStateProperty.all(Colors.lightGreen) : MaterialStateProperty.all(Colors.pinkAccent)
                                ),
                              ))),
                    ))),
          );
        });
  }
}
