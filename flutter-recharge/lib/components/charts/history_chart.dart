import 'dart:convert';

import 'package:best_flutter_ui_templates/api/auth.dart';
import 'package:best_flutter_ui_templates/api/getData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class HistoryChart extends StatefulWidget {
  const HistoryChart({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _HistoryChartState createState() => _HistoryChartState();
}

class _HistoryChartState extends State<HistoryChart> {
  bool _showD = false;
  late ZoomPanBehavior _zoomPanBehavior;
  var data;
  bool _loading = false;
  double t_tokens = 0;
  double t_points = 0;

  List<String> months = [
    'جانفي',
    'فيفري',
    'مارس',
    'افريل',
    'ماي',
    'جوان',
    'جويلية',
    'أوت',
    'سبتمبر',
    'اكتوبر',
    'نوفمبر',
    'ديسمبر'
  ];

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enableSelectionZooming: true,
      selectionRectBorderColor: Colors.red,
      selectionRectBorderWidth: 1,
      selectionRectColor: Colors.grey,
      enablePinching: true,
    );
    _getData();
    super.initState();
  }

  _getData() async {
    __getOldMonths();
    var res = await AuthApi().filterDates({});

    var body = res.data;
    if (body['status']) {
      var dataa = AuthApi().getData(body);

      setState(() {
        t_tokens = 0;
        t_points = 0;
        data = dataa['months'];
      });

      await GetData().updateMonths(data);
    }
  }

  __getOldMonths() async {
    var t = await GetData().getMonths();

    if (t != null) {
      setState(() {
        data = jsonDecode(t);
      });
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) async {
    var startDate = args.value.startDate;
    var endDate = args.value.endDate;

    if (startDate != null && endDate != null) {
      // send api to the server filtering data
      setState(() {
        _loading = true;
      });

      var res = await AuthApi().filterDates(
          {'end': endDate.toString(), 'start': startDate.toString()});


      var body = res.data;

      if (body['status']) {
        var dataa = AuthApi().getData(body);

        setState(() {
          t_tokens = 0;
          t_points = 0;
          data = dataa['months'];
        });
      }
      //
    }
  }

  getSalesDataToken() {
    if (data == null)
      return List<SalesData>.generate(
          months.length, (index) => SalesData(months[index], 0));
    else
      return List<SalesData>.generate(
          months.length,
          (index) {
            
            setState(() {
              t_tokens = t_tokens + data[(index + 1).toString()]['token_cash'];
            });

            return SalesData(
              months[index],
              double.parse(
                  data[(index + 1).toString()]['token_cash'].toString()));
          });
  }

  getSalesDataPOint() {
    if (data == null)
      return List<SalesData>.generate(
          months.length, (index) => SalesData(months[index], 0));
    else
      return List<SalesData>.generate(
          months.length,
          (index) {
            setState(() {
              t_points = t_points + data[(index + 1).toString()]['point_cash'];
            });

            return SalesData(
              months[index],
              double.parse(
                  data[(index + 1).toString()]['point_cash'].toString()));
          });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('بحث حسب التاريخ :'),
            IconButton(
              icon: const Icon(Icons.date_range),
              tooltip: 'بحث حسب التاريخ',
              color: _showD ? Colors.green : null,
              onPressed: () {
                setState(() {
                  _showD = !_showD;
                  t_tokens = 0;
                  t_points = 0;
                });
              },
            ),
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
        Center(
            child: Container(
                // height of the Container widget
                height: MediaQuery.of(context).size.height / 2,
                // width of the Container widget
                width: double.infinity,
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: SfCartesianChart(
                      // title: ChartTitle(text: 'Half yearly sales analysis'), //Chart title.
                      legend: Legend(isVisible: true), // Enables the legend.
                      // tooltipBehavior: ChartTooltipBehavior(enable: true), // Enables the tooltip.
                      primaryXAxis: CategoryAxis(
                        interval: 1,
                      ),
                      zoomPanBehavior: _zoomPanBehavior,
                      series: <LineSeries<SalesData, String>>[
                        LineSeries<SalesData, String>(
                            name: 'تاوكنز',
                            dataSource: getSalesDataToken(),
                            color: Colors.green,
                            xValueMapper: (SalesData sales, _) => sales.year,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                            ) // Enables the data label.
                            ),
                        LineSeries<SalesData, String>(
                            name: 'مسرعات',
                            dataSource: getSalesDataPOint(),
                            color: Colors.pinkAccent,
                            xValueMapper: (SalesData sales, _) => sales.year,
                            yValueMapper: (SalesData sales, _) => sales.sales,
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true) // Enables the data label.
                            )
                      ]),
                ))),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text.rich(
                TextSpan(
                    text: 'كلفة التاوكنز : ',
                    children: <InlineSpan>[
                      TextSpan(
                        text: '',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold,color: Colors.lightGreen),
                      ),
                      TextSpan(
                        text: '',
                        // style: TextStyle(
                        //     fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: t_tokens.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,color: Colors.lightGreen),
                      ),
                      TextSpan(
                        text: '',
                        // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ]),
                textAlign: TextAlign.start,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
               Text.rich(
                TextSpan(
                    text: 'كلفة المسرعات : ',
                    children: <InlineSpan>[
                      TextSpan(
                        text: '',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold,color: Colors.lightGreen),
                      ),
                      TextSpan(
                        text: '',
                        // style: TextStyle(
                        //     fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: t_points.toString(),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold,color: Colors.pinkAccent),
                      ),
                      TextSpan(
                        text: '',
                        // style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                      ),
                    ]),
                textAlign: TextAlign.start,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
                  ],
                )
      ],
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double? y;
}
