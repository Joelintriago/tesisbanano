


import 'package:flutter/material.dart';

class RegistroRacimoDataSource extends DataTableSource{
  final BuildContext context;

  RegistroRacimoDataSource(this.context);
  @override
  DataRow? getRow(int index) {
     return DataRow.byIndex(index: index, cells: [
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
    ]);
    
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => 5;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

}