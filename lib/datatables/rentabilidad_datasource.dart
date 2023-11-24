// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:admin_dashboard/models/costos.dart';
import 'package:admin_dashboard/models/parametrizacion.dart';
import 'package:admin_dashboard/models/rentabilidad.dart';
import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RentabilidadDataSource extends DataTableSource {
  final List<Rentabilidad> rentabilidades;
  final List<Costos> costos;
  final List<Parametrizacion> planeacion;
  final BuildContext context;
  final bool reporte;
  RentabilidadDataSource(this.rentabilidades, this.context, this.costos,
      this.planeacion, this.reporte);

  @override
  DataRow getRow(int index) {
    final Rentabilidad rentabilidad = rentabilidades[index];
    //int? selectedInventarioId=rentabilidad.inventoryId;
// ignore: unused_local_variable

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(rentabilidad.id.toString())),
        DataCell(Text(
            "Lote #" + rentabilidad.planningSowing2.batchNumber.toString())),
        DataCell(Text((rentabilidad.planningSowing2.numberOfBunches -
                rentabilidad.planningSowing2.rejectedBunches)
            .toString())),
        DataCell(Text(((rentabilidad.planningSowing2.averageBunchWeight *
                    (rentabilidad.planningSowing2.numberOfBunches -
                        rentabilidad.planningSowing2.rejectedBunches) /
                    1000))
                .toStringAsFixed(2) +
            "KG")),
        DataCell(
          Text(
            (((rentabilidad.planningSowing2.averageBunchWeight *
                                (rentabilidad.planningSowing2.numberOfBunches -
                                    rentabilidad
                                        .planningSowing2.rejectedBunches)) /
                            1000) *
                        2.2) // Conversión de kilogramos a libras
                    .toStringAsFixed(2) +
                "LB",
          ),
        ),
        DataCell(
          Text(
            ((rentabilidad.planningSowing2.averageBunchWeight *
                        (rentabilidad.planningSowing2.numberOfBunches -
                            rentabilidad.planningSowing2.rejectedBunches) /
                        1000) >=
                    29)
                ? "RENTABLE"
                : "NO RENTABLE",
            style: TextStyle(
              color: (rentabilidad.planningSowing2.averageBunchWeight *
                          (rentabilidad.planningSowing2.numberOfBunches -
                              rentabilidad.planningSowing2.rejectedBunches) /
                          1000) >=
                      29
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ),
        if (reporte != true)
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final usersProvider =
                        Provider.of<UsersProvider>(context, listen: false);
                    await usersProvider.deleteRentabilidad(rentabilidad.id);
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => this.rentabilidades.length;

  @override
  int get selectedRowCount => 0;
}
