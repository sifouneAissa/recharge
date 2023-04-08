import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator/add_token_form.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/main.dart';
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
  List<String> columns = [
    '#',
    'الحالة',
    S().count,
    S().cost_d,
    'معرف الحساب',
    S().date
  ];

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
    if (transaction['waiting'])
      text = 'يتم مراجعة الطلب';
    else if (transaction['accepted'])
      text = 'تم قبول الطلب';
    else if (transaction['rejected']) text = 'تم رفض طلبك';
    else if (transaction['more']) text = transaction['status']['message'];

    return Text(text, style: TextStyle(fontWeight: FontWeight.bold));
  }

  transactionColors(transaction) {
    Color? color;
    if (transaction['waiting'])
      color = Colors.grey.withOpacity(0.1);
    else if (transaction['accepted'])
      color = Colors.greenAccent.withOpacity(0.1);
    else if (transaction['rejected']) color = Colors.redAccent.withOpacity(0.1);
    else if (transaction['more']) color = Colors.redAccent.withOpacity(0.1);

    return color;
  }

  getTokens(tokensPackages) {
    // double _cost = 0;
    var _tokens = 0;
    tokensPackages.forEach((element) {
      PackageTokenData elementT = PackageTokenData(
          value: element['count'],
          packageData: element['token_package'],
          packageId: element['user_transaction_id']);

      var ttokens = 0;

      // int ncost = elementT.packageData['cost'] * double.parse(elementT.value) + ncost;
      ttokens =
          elementT.packageData['count'] * int.parse(elementT.value) + ttokens;

      // _cost = ncost + .0;
      _tokens = _tokens + ttokens;
    });

    return _tokens;
  }

  _getItemsList(tokensPackages) {
    return List.generate(tokensPackages.length, (index) {
      PackageTokenData element = PackageTokenData(
          value: tokensPackages[index]['count'],
          packageData: tokensPackages[index]['token_package'],
          packageId: tokensPackages[index]['user_transaction_id']);

      return Container(
        margin: EdgeInsets.only(top: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey.withOpacity(0.3),
          // border: Border.all(color: Colors.black)
        ),
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(right: 0),
                child: Text(
                  Common.formatNumber(element.packageData['count']),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                margin: EdgeInsets.only(right: 80),
                child: Text(Common.formatNumber(int.parse(element.value)),
                    overflow: TextOverflow.ellipsis),
              ),
              // Container(
              //   width: MediaQuery.of(context).size.width * 0.2,
              //   margin: EdgeInsets.only(right: 30),
              //   child:
              //       Text(cost.substring(0, cost.length > 5 ? 5 : cost.length)),
              // )
            ],
          ),
        ),
      );
    });
  }

  _getPackages(tokensPackages) {
    int _tokens = getTokens(tokensPackages);
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Text.rich(TextSpan(children: [
                TextSpan(
                    text: '-', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                    text: S.of(context).transaction_package_selected,
                    style: TextStyle(fontWeight: FontWeight.bold))
              ])),
            ),
          ],
        ),
        Container(
          height: 2,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            // border: Border.all(color: Colors.black)
          ),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 60),
                  child: Text(S.of(context).transaction_package),
                ),
                Container(
                  margin: EdgeInsets.only(right: 60),
                  child: Text(S.of(context).transaction_package_count),
                ),
                // Container(
                //   margin: EdgeInsets.only(right: 80),
                //   child: Text(' الكلفة'),
                // )
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: _getItemsList(tokensPackages),
          ),
        ),
        Container(
          height: 15,
        ),
        Container(
          // width: MediaQuery.of(context).size.width * 0.5,
          // height: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: FitnessAppTheme.grey.withOpacity(0.4),
                    offset: const Offset(1.1, 1.1),
                    blurRadius: 10.0),
              ]),
          child: Column(
            children: [
              Container(
                // height: MediaQuery.of(context).size.height * 0.1,
                // width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <HexColor>[
                        HexColor('#260202'),
                        HexColor('#F0AB2B'),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),

                child: Padding(
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, right: 50, left: 50),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(Common.formatNumber(_tokens),
                          style: TextStyle(
                              fontSize: 20, color: Colors.amberAccent))),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    // color: Colors.white
                    ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                          S.of(context).tokens + Common.formatNumber(_tokens))),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  transactionIcon(transaction) {
    Widget? image = SizedBox();
    if (transaction['waiting'])
      image = Image.asset(
        'assets/icons/loading.gif',
        width: 20,
      );
    return image;
  }

  bottomSheetBuilder(transaction) {
    var tokensPackages = transaction['token_packages'];

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 400,
            child: Container(
              decoration: BoxDecoration(
              color: transactionColors(transaction),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              margin: EdgeInsets.only(top: 0),
              child: ListView(
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                              S.of(context).bottom_sheet_transaction_token),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(S.of(context).transaction_status),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  transactionStatus(transaction),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  transactionIcon(transaction)
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(S.of(context).transaction_count),
                              Text(
                                Common.formatNumber(transaction['count']),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(S.of(context).transaction_price),
                              Text(Common.formatNumber(transaction['cost']),
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(S.of(context).transaction_date),
                              Text(transaction['tdate'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: FitnessAppTheme.nearlyDarkBlue))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10, top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [_getPackages(tokensPackages)],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
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
                                  color: MaterialStatePropertyAll(
                                      transactionColors(transactions[counter])),

                                  cells: [
                                    DataCell(
                                      Text(
                                        '#' +
                                            transactions[counter]['id']
                                                .toString(),
                                        style: TextStyle(
                                            color:
                                                FitnessAppTheme.nearlyDarkBlue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          transactionStatus(
                                              transactions[counter]),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          transactionIcon(transactions[counter])
                                        ],
                                      ),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    ),
                                    DataCell(
                                      Text(
                                        Common.formatNumber(
                                            transactions[counter]['count']),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    ),
                                    DataCell(
                                      Text(
                                          Common.formatNumber(
                                              transactions[counter]['cost']),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    ),
                                    DataCell(Text(transactions[counter]
                                            ['account_id']
                                        .toString())),
                                    DataCell(
                                      Text(
                                          transactions[counter]['tdate']
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: FitnessAppTheme
                                                  .nearlyDarkBlue)),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    )
                                  ],
                                  // color: transactions[counter]['type'].toString() == 'token' ? MaterialStateProperty.all(Colors.lightGreen) : MaterialStateProperty.all(Colors.pinkAccent)
                                ),
                              ))),
                    ))),
          );
        });
  }
}
