
import 'package:flutter/material.dart';

import 'package:admin_dashboard/models/tipoReporte.dart';

import 'package:provider/provider.dart';
import 'package:admin_dashboard/providers/users_provider.dart';

import 'package:admin_dashboard/ui/widgets/reports/planing_table_report.dart';
import 'package:admin_dashboard/ui/widgets/reports/users_table_report.dart';
import 'package:admin_dashboard/ui/widgets/reports/costos_table_report.dart';
import 'package:admin_dashboard/ui/widgets/reports/inventory_table_report.dart';

class ReportesView extends StatefulWidget {

  @override
  State<ReportesView> createState() => _ReportesViewState();
}

class _ReportesViewState extends State<ReportesView> {
  int c = 0;
  String nombreReporte = "";
  int? selectedTipoReporteId;
  @override
  void didChangeDependencies() {
    if (c == 0) {
      super.didChangeDependencies();
      Provider.of<UsersProvider>(context).getInventario();
      Provider.of<UsersProvider>(context).getTipoReporte();
      Provider.of<UsersProvider>(context).getPermisos();
      Provider.of<UsersProvider>(context).getPermisosRol(1);
      Provider.of<UsersProvider>(context).getSiembra();
      Provider.of<UsersProvider>(context).getRentabilidad();
      Provider.of<UsersProvider>(context).getCostos();
      c++;
    }
  }

  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);

    final permisos = usersProvider.permisos;
    final tipoRepo = usersProvider.reporteTipos;

    return SingleChildScrollView(
      child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(183, 198, 199, 157).withOpacity(0.9),
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width *
                            0.4, // Ancho del Card, puedes ajustarlo según tus necesidades
                        child: DropdownButtonFormField<ReporteTipo>(
                          isExpanded: true,
                          value: null,
                          isDense:
                              true, // Reduce el espacio vertical entre los elementos del menú desplegable
                          decoration: InputDecoration(
                              labelText: 'Escoja tipo de Reporte'),
                          items: tipoRepo
                              .map<DropdownMenuItem<ReporteTipo>>(
                                (ReporteTipo reportT) =>
                                    DropdownMenuItem<ReporteTipo>(
                                  value: reportT,
                                  child: Text(reportT.reportName),
                                ),
                              )
                              .toList(),
                          onChanged: (ReporteTipo? value) async {
                            selectedTipoReporteId = value?.id;
                            nombreReporte = value?.reportName ?? "";
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  if (selectedTipoReporteId == 1 &&
                      usersProvider.users.isNotEmpty &&
                      permisos.isNotEmpty)
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: UsersTableReport(nombreReporte: nombreReporte),
                      ),
                    ),
                  if (selectedTipoReporteId == 2)
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child: PlaningTableReport(nombreReporte: nombreReporte),
                      ),
                    ),
                  if (selectedTipoReporteId == 3)
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child:
                            InvetoryTableReport(nombreReporte: nombreReporte),
                      ),
                    ),
                  if (selectedTipoReporteId == 4)
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        child:
                            CostosTableReport(nombreReporte: nombreReporte),
                      ),
                    )
                ],
              ),
            ),
          )),
    );
  }
}

//Funciones
