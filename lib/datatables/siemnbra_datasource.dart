import 'package:flutter/material.dart';

class SiembraDataSource extends DataTableSource {
  final BuildContext context;

  SiembraDataSource(this.context);
  @override
  DataRow? getRow(int index) {
    // TODO: implement getRow
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
      DataCell(Text('index $index')),
       DataCell(Text('Acciones')),

    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => 6;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;
}
