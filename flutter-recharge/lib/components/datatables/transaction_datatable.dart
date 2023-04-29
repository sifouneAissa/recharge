import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/constants.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator/add_jawaker_accelerator_form.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator/add_token_form.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/models/jawaker_list_data.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:best_flutter_ui_templates/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';

class TransactionDatatable extends StatefulWidget {
  const TransactionDatatable(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.parentScrollController})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final ScrollController? parentScrollController;

  @override
  _TransactionDatatable createState() => _TransactionDatatable();
}

class _TransactionDatatable extends State<TransactionDatatable>
    with TickerProviderStateMixin {
  AnimationController? animationController;

  var transactions = [];
  var stransactions = [];
  bool _copied = false;
  int todayt = 0;
  bool _showD = false;
  bool _loading = false;
  String selectedValue = "none";
  String? sDate;
  String? eDate;
  String? ttransaction;

  List<String> columns = [
    '#',
    'الحالة',
    S().count,
    S().cost_d,
    'اسم اللاعب',
    'معرف اللاعب',
    S().transaction_type,
    S().date
  ];
  TextEditingController search = TextEditingController();

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
        stransactions = data['transactions'];
        _getToday();
      });

      await GetData().updateTransactions(transactions);
    }
  }

  __getOldTransactions() async {
    var t = await GetData().getTransaction();
    if (t != null) {
      setState(() {
        transactions = jsonDecode(t);
        stransactions = transactions;
      });

      _getToday();
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    __getTransactions();
    super.initState();

    widget.parentScrollController?.addListener(() async {
      if (widget.parentScrollController?.position.pixels ==
          widget.parentScrollController?.position.minScrollExtent) {
        await __getTransactions();
      }
    });

    search.addListener(() {
      if (search.value.text.isNotEmpty) {
        var t = transactions
            .where((element) =>
                element['account_id'].toString().contains(search.value.text) ||
                element['name_of_player']
                    .toString()
                    .contains(search.value.text))
            .toList();

        setState(() {
          stransactions = t;
        });
      } else
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

  transactionText(transaction) {
    String text = '';
    if (transaction['waiting'])
      text = 'يتم مراجعة الطلب';
    else if (transaction['accepted'])
      text = 'تم قبول الطلب';
    else if (transaction['rejected'])
      text = 'تم رفض طلبك';
    else if (transaction['more']) text = transaction['status']['message'];

    return text;
  }

  getTextToCopy(transaction) {
    String status = 'الحالة : ' + transactionText(transaction);
    String quantity = 'الحزم : ' + Common.formatNumber(transaction['count']);
    String account_id =
        S.of(context).transaction_player_id + transaction['account_id'];
    String day = S.of(context).transaction_date + transaction['tdate'];

    return '$status $quantity $account_id $day';
  }

  getTextToCopyPoint(transaction) {
    String status = 'الحالة : ' + transactionText(transaction);
    String quantity = 'القيمة : ' + Common.formatNumber(transaction['count']);
    String account_id =
        S.of(context).transaction_player_id + transaction['account_id'];
    String day = S.of(context).transaction_date + transaction['tdate'];

    return '$status $quantity $account_id $day';
  }

  getTokens(tokensPackages) {
    // double _cost = 0;
    var _tokens = 0;
    tokensPackages.forEach((element) {
      PackageTokenData elementT = PackageTokenData(
          value: element['count'] is String
              ? element['count']
              : element['count'].toString(),
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

  getPackage(name) {
    Widget myWidget = Container();
    try {
      JawakerListData element = JawakerListData.tabIconsList
          .firstWhere((element) => element.kacl == int.parse(name.toString()));

      myWidget = FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            child: Container(
              height: 216,
              width: MediaQuery.of(context).size.width * 0.4,
              child: JawakerView(
                  animation: widget.mainScreenAnimation,
                  animationController: widget.mainScreenAnimationController,
                  isSelected: false,
                  mealsListData: element),
            ),
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
          ));
    } catch (e) {}

    return myWidget;
  }

  showSubSheetBuilder(transaction) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                margin: EdgeInsets.only(top: 0),
                child: Column(children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('معلومات حول الحزمة'),
                        )
                      ],
                    ),
                  ),
                  transaction['message'] != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(transaction['message'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: FitnessAppTheme.nearlyDarkBlue))
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(S.of(context).transaction_status),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            transactionSubStatus(transaction),
                            SizedBox(
                              width: 10,
                            ),
                            subTransactionIcon(transaction)
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
                        Text('الحزمة : '),
                        Text(
                          Common.formatNumber(transaction['total_tokens']),
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
                        Text('الكمية : '),
                        Text(Common.formatNumber(transaction['total_quantity']),
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  transaction['accepted_token'] != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('الكمية التي تم قبولها : '),
                              Text(
                                  Common.formatNumber(
                                      transaction['accepted_token'] == null
                                          ? 0
                                          : transaction['accepted_token']),
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        )
                      : Container(),
                  transaction['rest_token'] != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('الكمية التي تم رفضها : '),
                              Text(
                                  Common.formatNumber(
                                      transaction['rest_token']),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red))
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(S.of(context).transaction_date),
                        Text(transaction['tupdated_at'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: FitnessAppTheme.nearlyDarkBlue))
                      ],
                    ),
                  ),
                ])),
          );
        });
  }

  showSubSheetBuilderPoint(transaction, ptransaction) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                margin: EdgeInsets.only(top: 0),
                child: Column(children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('معلومات حول المسرع'),
                        )
                      ],
                    ),
                  ),
                  transaction['message'] != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(transaction['message'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: FitnessAppTheme.nearlyDarkBlue))
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(S.of(context).transaction_status),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            transactionSubStatus(transaction),
                            SizedBox(
                              width: 10,
                            ),
                            subTransactionIcon(transaction)
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
                        Text('المسرع : '),
                        Text(
                          ptransaction['package_name'] != null
                              ? ptransaction['package_name']
                              : '',
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
                        Text('الكمية : '),
                        Text(Common.formatNumber(transaction['total_quantity']),
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  transaction['accepted_point'] != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('الكمية التي تم قبولها : '),
                              Text(
                                  Common.formatNumber(
                                      transaction['accepted_point'] == null
                                          ? 0
                                          : transaction['accepted_point']),
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        )
                      : Container(),
                  transaction['rest_token'] != null
                      ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('الكمية التي تم رفضها : '),
                              Text(
                                  Common.formatNumber(
                                      transaction['rest_token']),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red))
                            ],
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(S.of(context).transaction_date),
                        Text(transaction['tupdated_at'].toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: FitnessAppTheme.nearlyDarkBlue))
                      ],
                    ),
                  ),
                ])),
          );
        });
  }

  _getItemsList(transaction) {
    var tokensPackages = transaction['token_packages'];

    return List.generate(tokensPackages.length, (index) {
      PackageTokenData element = PackageTokenData(
          value: tokensPackages[index]['count'] is String
              ? tokensPackages[index]['count']
              : tokensPackages[index]['count'].toString(),
          packageData: tokensPackages[index]['token_package'],
          packageId: tokensPackages[index]['user_transaction_id']);

      Widget status =
          subTransactionIcon(tokensPackages[index]['token_operation']);

      return GestureDetector(
        onTap: () {
          if (tokensPackages[index]['token_operation'] != null)
            showSubSheetBuilder(tokensPackages[index]['token_operation']);
        },
        child: Container(
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
                  margin: EdgeInsets.only(right: 20),
                  child: Text(Common.formatNumber(int.parse(element.value)),
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  margin: EdgeInsets.only(right: 10),
                  child: status,
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
        ),
      );
    });
  }

  _getItemsListPoint(transaction) {
    var tokensPackages = transaction['point_packages'];

    return List.generate(tokensPackages.length, (index) {
      PackagePointData element = PackagePointData(
          value: tokensPackages[index]['count'] is String
              ? tokensPackages[index]['count']
              : tokensPackages[index]['count'].toString(),
          packageData: tokensPackages[index]['point_package'],
          packageId: tokensPackages[index]['user_transaction_id']);

      Widget status =
          subTransactionIcon(tokensPackages[index]['point_operation']);

      return GestureDetector(
        onTap: () {
          if (tokensPackages[index]['point_operation'] != null)
            showSubSheetBuilderPoint(tokensPackages[index]['point_operation'],
                tokensPackages[index]);
        },
        child: Container(
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
                    element.packageData != null
                        ? element.packageData['name']
                        : '',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  margin: EdgeInsets.only(right: 20),
                  child: Text(Common.formatNumber(int.parse(element.value)),
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  margin: EdgeInsets.only(right: 10),
                  child: status,
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
        ),
      );
    });
  }

  _getPackages(transaction) {
    // var tokensPackages = transaction['token_packages'];
    // int _tokens = getTokens(tokensPackages) - transaction['left_accepted'];
    int _tokens = transaction['token_accepted'] != null
        ? transaction['token_accepted']
        : 0;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // margin: EdgeInsets.only(left: 60),
                  child: Text(S.of(context).transaction_package),
                ),
                Container(
                  width: 60,
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  child: Text(S.of(context).transaction_package_count),
                ),
                Container(
                  width: 60,
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  child: Text(' الحالة'),
                )
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: _getItemsList(transaction),
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

  _getPackagesPoint(transaction) {
    // var tokensPackages = transaction['token_packages'];
    // int _tokens = getTokens(tokensPackages) - transaction['left_accepted'];
    int _tokens = transaction['accepted_point'] != null
        ? transaction['accepted_point']
        : 0;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  // margin: EdgeInsets.only(left: 60),
                  child: Text(S.of(context).transaction_package),
                ),
                Container(
                  width: 60,
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  child: Text(S.of(context).transaction_package_count),
                ),
                Container(
                  width: 60,
                ),
                Container(
                  margin: EdgeInsets.only(right: 0),
                  child: Text(' الحالة'),
                )
              ],
            ),
          ),
        ),
        Container(
          child: Column(
            children: _getItemsListPoint(transaction),
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
                        HexColor('#2633C5'),
                        HexColor('#2633C5'),
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
                      child: Text('القيمة : ' + Common.formatNumber(_tokens))),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  transactionSubStatus(transaction) {
    String text = '';
    if (transaction['status'] == 'waiting')
      text = 'يتم مراجعة الحزمة';
    else if (transaction['status'] == 'accepted')
      text = 'تم قبول الحزمة';
    else if (transaction['status'] == 'rejected')
      text = 'تم رفض الحزمة';
    else if (transaction['more']) text = transaction['status']['message'];

    return Text(text, style: TextStyle(fontWeight: FontWeight.bold));
  }

  subTransactionIcon(transaction) {
    Widget? image = SizedBox();
    if (transaction != null) if (transaction['status'] == 'waiting')
      image = Image.asset(
        'assets/icons/loading.gif',
        width: 20,
        height: 20,
      );
    else if (transaction['status'] == 'accepted') {
      image = Icon(
        Icons.check,
        color: Colors.green,
        size: 20,
      );
    } else if (transaction['status'] == 'rejected') {
      image = Icon(
        Icons.close,
        color: Colors.redAccent,
        size: 20,
      );
    }

    return image;
  }

  transactionSubStatusPoint(transaction) {
    String text = '';
    if (transaction['status'] == 'waiting')
      text = 'يتم مراجعة المسرع';
    else if (transaction['status'] == 'accepted')
      text = 'تم قبول المسرع';
    else if (transaction['status'] == 'rejected')
      text = 'تم رفض المسرع';
    else if (transaction['more']) text = transaction['status']['message'];

    return Text(text, style: TextStyle(fontWeight: FontWeight.bold));
  }

  bottomSheetBuilderToken(transaction) {
    bool isW = transaction['waiting'];
    setState(() {
      _copied = false;
    });
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: 450,
              child: Container(
                  decoration: BoxDecoration(
                    color: transactionColors(transaction),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  margin: EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: getTextToCopy(transaction)));
                                  setState(() {
                                    _copied = true;
                                  });
                                },
                                child: Icon(
                                  Icons.copy,
                                  size: 30,
                                  color: _copied
                                      ? Colors.greenAccent
                                      : FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                  S.of(context).bottom_sheet_transaction_token),
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
                            Text(S.of(context).transaction_status),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Text('الحزم : '),
                            Text(
                              Common.formatNumber(transaction['count']),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(right: 10),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text(S.of(context).transaction_price),
                      //       Text(Common.formatNumber(transaction['cost']),
                      //           style: TextStyle(fontWeight: FontWeight.bold))
                      //     ],
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(S.of(context).transaction_player_id),
                            Text(transaction['account_id'].toString(),
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
                      isW
                          ? Container()
                          : transaction['message'] != null ||
                                  transaction['player_name'] != null
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 20, right: 30, left: 30),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: FitnessAppTheme.nearlyDarkBlue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        transaction['message'] != null
                                            ? Container(
                                                // margin: EdgeInsets.only(right : 50,left: 50),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          transaction[
                                                              'message'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: FitnessAppTheme
                                                                  .nearlyDarkBlue)),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        transaction['player_name'] != null
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(right: 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('اسم اللاعب : '),
                                                    Text(
                                                        transaction[
                                                            'player_name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: FitnessAppTheme
                                                                .nearlyDarkBlue))
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        // Container(
                                        //   margin: EdgeInsets.only(right: 10),
                                        //   child: Row(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       Text('الكمية التي تم رفضها : '),
                                        //       Text(
                                        //           Common.formatNumber(
                                        //               transaction['left_accepted']),
                                        //           style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: Colors.redAccent))
                                        //     ],
                                        //   ),
                                        // ),
                                        // Container(
                                        //   margin: EdgeInsets.only(right: 10),
                                        //   child: Row(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       Text('الكمية التي تم قبولها : '),
                                        //       Text(
                                        //           Common.formatNumber(
                                        //               transaction['token_accepted']),
                                        //           style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: FitnessAppTheme
                                        //                   .nearlyDarkBlue))
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),

                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10, top: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [_getPackages(transaction)],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          });
        });
  }

  bottomSheetBuilderPoint(transaction) {
    bool isW = transaction['waiting'];
    setState(() {
      _copied = false;
    });
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: 450,
              child: Container(
                  decoration: BoxDecoration(
                    color: transactionColors(transaction),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  margin: EdgeInsets.only(top: 0),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                      text: getTextToCopyPoint(transaction)));
                                  setState(() {
                                    _copied = true;
                                  });
                                },
                                child: Icon(
                                  Icons.copy,
                                  size: 30,
                                  color: _copied
                                      ? Colors.greenAccent
                                      : FitnessAppTheme.nearlyDarkBlue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text(
                                  S.of(context).bottom_sheet_transaction_token),
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
                            Text(S.of(context).transaction_status),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            Text('القيمة : '),
                            Text(
                              Common.formatNumber(transaction['count']),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(right: 10),
                      //   child: Row(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //       Text(S.of(context).transaction_price),
                      //       Text(Common.formatNumber(transaction['cost']),
                      //           style: TextStyle(fontWeight: FontWeight.bold))
                      //     ],
                      //   ),
                      // ),
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(S.of(context).player_name),
                            Text(transaction['player_name'].toString(),
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
                      isW
                          ? Container()
                          : transaction['message'] != null ||
                                  transaction['player_name'] != null
                              ? Container(
                                  margin: EdgeInsets.only(
                                      top: 20, right: 30, left: 30),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: FitnessAppTheme.nearlyDarkBlue),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        transaction['message'] != null
                                            ? Container(
                                                // margin: EdgeInsets.only(right : 50,left: 50),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                          transaction[
                                                              'message'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: FitnessAppTheme
                                                                  .nearlyDarkBlue)),
                                                    )
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        transaction['player_name'] != null
                                            ? Container(
                                                margin:
                                                    EdgeInsets.only(right: 0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text('اسم اللاعب : '),
                                                    Text(
                                                        transaction[
                                                            'player_name'],
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: FitnessAppTheme
                                                                .nearlyDarkBlue))
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                        // Container(
                                        //   margin: EdgeInsets.only(right: 10),
                                        //   child: Row(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       Text('الكمية التي تم رفضها : '),
                                        //       Text(
                                        //           Common.formatNumber(
                                        //               transaction['left_accepted']),
                                        //           style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: Colors.redAccent))
                                        //     ],
                                        //   ),
                                        // ),
                                        // Container(
                                        //   margin: EdgeInsets.only(right: 10),
                                        //   child: Row(
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       Text('الكمية التي تم قبولها : '),
                                        //       Text(
                                        //           Common.formatNumber(
                                        //               transaction['token_accepted']),
                                        //           style: TextStyle(
                                        //               fontWeight: FontWeight.bold,
                                        //               color: FitnessAppTheme
                                        //                   .nearlyDarkBlue))
                                        //     ],
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container(),

                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(right: 10, top: 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _getPackagesPoint(transaction)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            );
          });
        });
  }

  transactionStatus(transaction) {
    String text = '';
    if (transaction['waiting'])
      text = 'يتم مراجعة الطلب';
    else if (transaction['accepted'])
      text = 'تم قبول الطلب';
    else if (transaction['rejected'])
      text = 'تم رفض طلبك';
    else if (transaction['more']) text = transaction['status']['message'];

    return Text(text, style: TextStyle(fontWeight: FontWeight.bold));
  }

  transactionColors(transaction) {
    Color? color;
    if (transaction['waiting'])
      color = Colors.grey.withOpacity(0.1);
    else if (transaction['accepted'])
      color = Colors.greenAccent.withOpacity(0.1);
    else if (transaction['rejected'])
      color = Colors.redAccent.withOpacity(0.1);
    else if (transaction['more']) color = Colors.redAccent.withOpacity(0.1);

    return color;
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

  _getToday() {
    int t = 0;
    transactions.forEach((element) {
      if (element['is_today'] == true) t++;
    });

    setState(() {
      todayt = t;
    });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    var startDate;
    var endDate;

    try {
      startDate = args.value.startDate as DateTime;
      endDate = args.value.endDate as DateTime;
    } catch (error) {}

    if (startDate != null && endDate != null) {
      var t = transactions.where(
        (element) {
          var ldate = DateTime.parse(element['created_at']);
          return ldate.isBefore(endDate) && ldate.isAfter(startDate);
        },
      ).toList();

      setState(() {
        stransactions = t;
        
        final DateFormat formatter = DateFormat('yyyy-MM-dd','en');
        sDate = formatter.format(args.value.startDate).toString();
        eDate = formatter.format(args.value.endDate).toString();
      });
    } else
      setState(() {
        stransactions = transactions;
      });
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
        child: Text("اختر نوع"),
        value: "none",
        onTap: () {
          setState(() {
            stransactions = transactions;
          });
        },
      ),
      DropdownMenuItem(
        child: Text("توكنز"),
        value: "token",
        onTap: () {
          var t = transactions.where(
            (element) {
              return element['type'] == 'token';
            },
          ).toList();

          setState(() {
            stransactions = t;
          });
        },
      ),
      DropdownMenuItem(
        child: Text("مسرعات"),
        value: "point",
        onTap: () {
          var t = transactions.where(
            (element) {
              return element['type'] == 'point';
            },
          ).toList();

          setState(() {
            stransactions = t;
          });
        },
      ),
    ];
    return menuItems;
  }

  

_launchURL() async {
  
  var auth = await GetData().getAuth();

  String b_url = AuthApi().getUrl('transactions/pdf/download/'+auth['id'].toString()) + '?';
  
  if(ttransaction!=null){
    b_url = b_url + '&type=' + ttransaction.toString();
  } 
  if(sDate != null && eDate != null){
    b_url = b_url + '&end=' + eDate.toString();
    b_url = b_url + '&start=' + sDate.toString();
  }

  final uri = Uri.parse(b_url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri,mode: LaunchMode.externalApplication);
  } else {
    print('could not lunch url');
  }
}

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: widget.mainScreenAnimationController!,
        builder: (BuildContext context, Widget? child) {
          return Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.33,
                margin: EdgeInsets.only(right: 250),
                // height: MediaQuery.of(context).size.height * 0.33,
                decoration: BoxDecoration(
                    border: Border.all(color: FitnessAppTheme.nearlyDarkBlue),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('اليوم : ' + todayt.toString()),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    child: Text('بحث حسب التاريخ :'),
                    onTap: () {
                      setState(() {
                        _showD = !_showD;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.date_range),
                    tooltip: 'بحث حسب التاريخ',
                    color: _showD ? Colors.green : null,
                    onPressed: () {
                      setState(() {
                        _showD = !_showD;
                      });
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: DropdownButton(
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedValue = newValue!;
                            ttransaction = selectedValue;
                          });
                        },
                        value: selectedValue,
                        items: dropdownItems),
                  )
                ],
              ),
              _showD
                  ? Center(
                      child: SfDateRangePicker(
                        selectionMode: DateRangePickerSelectionMode.range,
                        navigationMode: DateRangePickerNavigationMode.snap,
                        onSelectionChanged: _onSelectionChanged,
                      ),
                    )
                  : Container(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                      child: TextFormField(
                    controller: search,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    cursorColor: kPrimaryColor,
                    // textDirection: TextDirection.rtl,
                    onSaved: (email) {},
                    decoration: InputDecoration(
                      hintText: 'بحث عن طريق الاسم او معرف الحساب',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(defaultPadding),
                        child: Icon(Icons.search,
                            color: FitnessAppTheme.nearlyDarkBlue),
                      ),
                    ),
                  )),
                  IconButton(onPressed: () {
                    _launchURL();
                  }, icon: Icon(Icons.download,color: FitnessAppTheme.nearlyDarkBlue,))
                ],
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: List<DataColumn>.generate(
                              columns.length,
                              (counter) => DataColumn(
                                      label: Text(
                                    columns[counter],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: FitnessAppTheme.nearlyDarkBlue),
                                  ))),
                          rows: List<DataRow>.generate(
                            stransactions.length,
                            (counter) => DataRow(
                              color: MaterialStatePropertyAll(
                                  transactionColors(transactions[counter])),
                              cells: [
                                DataCell(
                                  Text(
                                    '#' +
                                        transactions[counter]['id'].toString(),
                                    style: TextStyle(
                                        color: FitnessAppTheme.nearlyDarkBlue,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    stransactions[counter]['type'].toString() ==
                                            'token'
                                        ? bottomSheetBuilderToken(
                                            stransactions[counter])
                                        : bottomSheetBuilderPoint(
                                            stransactions[counter]);
                                  },
                                ),
                                DataCell(
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      transactionStatus(stransactions[counter]),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      transactionIcon(stransactions[counter])
                                    ],
                                  ),
                                  onTap: () {
                                    stransactions[counter]['type'].toString() ==
                                            'token'
                                        ? bottomSheetBuilderToken(
                                            stransactions[counter])
                                        : bottomSheetBuilderPoint(
                                            stransactions[counter]);
                                  },
                                ),
                                DataCell(
                                  Text(
                                    Common.formatNumber(
                                        stransactions[counter]['count']),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    stransactions[counter]['type'].toString() ==
                                            'token'
                                        ? bottomSheetBuilderToken(
                                            stransactions[counter])
                                        : bottomSheetBuilderPoint(
                                            stransactions[counter]);
                                  },
                                ),
                                DataCell(
                                  Text(
                                      Common.formatNumber(
                                          stransactions[counter]['cost']),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {
                                    stransactions[counter]['type'].toString() ==
                                            'token'
                                        ? bottomSheetBuilderToken(
                                            stransactions[counter])
                                        : bottomSheetBuilderPoint(
                                            stransactions[counter]);
                                  },
                                ),
                                DataCell(
                                  Text(
                                      stransactions[counter]
                                                  ['name_of_player'] !=
                                              null
                                          ? stransactions[counter]
                                                  ['name_of_player']
                                              .toString()
                                          : '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {
                                    stransactions[counter]['type'].toString() ==
                                            'token'
                                        ? bottomSheetBuilderToken(
                                            stransactions[counter])
                                        : bottomSheetBuilderPoint(
                                            stransactions[counter]);
                                  },
                                ),
                                DataCell(
                                  Text(
                                      stransactions[counter]['account_id'] !=
                                              null
                                          ? stransactions[counter]['account_id']
                                              .toString()
                                          : '',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  onTap: () {
                                    stransactions[counter]['type'].toString() ==
                                            'token'
                                        ? bottomSheetBuilderToken(
                                            stransactions[counter])
                                        : bottomSheetBuilderPoint(
                                            stransactions[counter]);
                                  },
                                ),
                                DataCell(
                                  stransactions[counter]['type'].toString() ==
                                          'token'
                                      ? Image.asset(
                                          'assets/fitness_app/tab_3s.png',
                                          width: 40,
                                        )
                                      : Image.asset(
                                          'assets/fitness_app/tab_2s.png',
                                          width: 40,
                                        ),
                                  onTap: () {
                                    stransactions[counter]['type'].toString() ==
                                            'token'
                                        ? bottomSheetBuilderToken(
                                            stransactions[counter])
                                        : bottomSheetBuilderPoint(
                                            stransactions[counter]);
                                  },
                                ),
                                DataCell(
                                  Text(
                                      stransactions[counter]['tdate']
                                          .toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              FitnessAppTheme.nearlyDarkBlue)),
                                  onTap: () {
                                    stransactions[counter]['type'].toString() ==
                                            'token'
                                        ? bottomSheetBuilderToken(
                                            stransactions[counter])
                                        : bottomSheetBuilderPoint(
                                            stransactions[counter]);
                                  },
                                )
                              ],
                              // color: transactions[counter]['type'].toString() == 'token' ? MaterialStateProperty.all(Colors.lightGreen) : MaterialStateProperty.all(Colors.pinkAccent)
                            ),
                          ))))
            ],
          );
        });
  }
}
