import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:best_flutter_ui_templates/fitness_app/common.dart';
import 'package:best_flutter_ui_templates/fitness_app/components/jawaker_accelerator_list_view.dart';
import 'package:best_flutter_ui_templates/fitness_app/fitness_app_theme.dart';
import 'package:best_flutter_ui_templates/fitness_app/models/jawaker_list_data.dart';
import 'package:best_flutter_ui_templates/fitness_app/models/tabIcon_data.dart';
import 'package:best_flutter_ui_templates/generated/l10n.dart';
import 'package:flutter/material.dart';

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';

class RecentPointTransactionDatatable extends StatefulWidget {
  const RecentPointTransactionDatatable(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.parentScrollController})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final ScrollController? parentScrollController;

  @override
  _RecentPointTransactionDatatable createState() =>
      _RecentPointTransactionDatatable();
}

class _RecentPointTransactionDatatable
    extends State<RecentPointTransactionDatatable>
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
    'اسم اللاعب',
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
            .where((element) => element['type'] == 'point')
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
            .where((element) => element['type'] == 'point')
            .toList()
            .take(5)
            .toList();
      });
    }
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

  bottomSheetBuilder(transaction) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: 410,
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        transaction['message'] != null ? Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(transaction['message'].toString(),style: TextStyle(
                                color: FitnessAppTheme.nearlyDarkBlue,
                                fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                        ) : Container(),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                        getPackage(transaction['count']),
                        // Container(
                        //   margin: EdgeInsets.only(right: 10),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Text(S.of(context).transaction_count),
                        //       Text(
                        //         Common.formatNumber(transaction['count']),
                        //         style: TextStyle(fontWeight: FontWeight.bold),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(S.of(context).player_name),
                              Text(
                                  transaction['name_of_player'] != null
                                      ? transaction['name_of_player'].toString()
                                      : '',
                                  style: TextStyle(fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(S.of(context).transaction_date),
                              Text(transaction['tdate'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: FitnessAppTheme.nearlyDarkBlue))
                            ],
                          ),
                        ),
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
                                    DataCell(Text(
                                      '#' +
                                          transactions[counter]['id']
                                              .toString(),
                                      style: TextStyle(
                                          color: FitnessAppTheme.nearlyDarkBlue,
                                          fontWeight: FontWeight.bold),
                                    )),
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
                                    DataCell(
                                      Text(
                                          transactions[counter]
                                                      ['name_of_player'] !=
                                                  null
                                              ? transactions[counter]
                                                      ['name_of_player']
                                                  .toString()
                                              : '',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      onTap: () {
                                        bottomSheetBuilder(
                                            transactions[counter]);
                                      },
                                    ),
                                    // DataCell(transactions[counter]['type'].toString() == 'token' ? Icon(Icons.wallet_outlined,color: FitnessAppTheme.nearlyBlue,size: 40,) : Icon(IconData(0xf0654, fontFamily: 'MaterialIcons'),color: Colors.amber, size: 40,)),
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
