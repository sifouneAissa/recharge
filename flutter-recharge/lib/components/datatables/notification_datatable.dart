import 'package:flutter/material.dart';

class NotificationDatatable extends StatefulWidget {
  @override
  _NotificationDatatable createState() => _NotificationDatatable();
}

class _NotificationDatatable extends State<NotificationDatatable> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: [
              DataColumn(
                  label: Text(
                'ID',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.red),
              )),
              DataColumn(
                  label: Text(
                'NAME',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.red),
              )),
              DataColumn(
                  label: Text(
                'AGE',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.red),
              )),
              DataColumn(
                  label: Text(
                'AGE',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.red),
              )),
              DataColumn(
                  label: Text(
                'AGE',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.red),
              )),
            ], rows: [
              DataRow(cells: [
                DataCell(Text('0001')),
                DataCell(Text('Zisan')),
                DataCell(Text('16')),
                DataCell(Text('22')),
                DataCell(Text('22')),
              ]),
              DataRow(cells: [
                DataCell(Text('0002')),
                DataCell(Text('Riyan')),
                DataCell(Text('21')),
                DataCell(Text('21')),
                DataCell(Text('21')),
              ]),
              DataRow(cells: [
                DataCell(Text('0003')),
                DataCell(Text('Safiq')),
                DataCell(Text('29')),
                DataCell(Text('21')),
                DataCell(Text('21')),
              ]),
              // DataRow(cells: [
              //   DataCell(Text('0004')),
              //   DataCell(Text('Faruk')),
              //   DataCell(Text('36')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0001')),
              //   DataCell(Text('Zisan')),
              //   DataCell(Text('16')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0002')),
              //   DataCell(Text('Riyan')),
              //   DataCell(Text('21')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0003')),
              //   DataCell(Text('Safiq')),
              //   DataCell(Text('29')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0004')),
              //   DataCell(Text('Faruk')),
              //   DataCell(Text('36')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0001')),
              //   DataCell(Text('Zisan')),
              //   DataCell(Text('16')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0002')),
              //   DataCell(Text('Riyan')),
              //   DataCell(Text('21')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0003')),
              //   DataCell(Text('Safiq')),
              //   DataCell(Text('29')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0004')),
              //   DataCell(Text('Faruk')),
              //   DataCell(Text('36')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0001')),
              //   DataCell(Text('Zisan')),
              //   DataCell(Text('16')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0002')),
              //   DataCell(Text('Riyan')),
              //   DataCell(Text('21')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0003')),
              //   DataCell(Text('Safiq')),
              //   DataCell(Text('29')),
              // ]),
              // DataRow(cells: [
              //   DataCell(Text('0004')),
              //   DataCell(Text('Faruk')),
              //   DataCell(Text('36')),
              // ]),
            ])));
  }
}
