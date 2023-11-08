import 'package:admin_dashboard/datatables/registro_racimo_datasource.dart';
import 'package:admin_dashboard/datatables/siemnbra_datasource.dart';
import 'package:flutter/material.dart';

class ParametrizacionView extends StatefulWidget {
  @override
  State<ParametrizacionView> createState() => _ParametrizacionViewState();
}

class _ParametrizacionViewState extends State<ParametrizacionView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: const Color.fromARGB(183, 198, 199, 157).withOpacity(0.9),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            PaginatedDataTable(
                header: const Text('Siembra'),
                columns: [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Cond.Climática')),
                  DataColumn(label: Text('Var. Banano')),
                  DataColumn(label: Text('Cant. pesticida')),
                  DataColumn(label: Text('Cant. Fertilizante')),
                  DataColumn(label: Text('Cant. semillas/plantas')),
                  DataColumn(label: Text('Fechas fumigación')),
                  DataColumn(label: Text('Riego ')),
                  DataColumn(label: Text('Acciones')),
                ],
                source: SiembraDataSource(context)),
            PaginatedDataTable(
                header: const Text('Registro de racimo'),
                columns: [
                  DataColumn(label: Text('Fecha inicio')),
                  DataColumn(label: Text('Fecha fin')),
                  DataColumn(label: Text('Tiempo estimado')),
                  DataColumn(label: Text('Num. racomps')),
                  DataColumn(label: Text('Num. rechazados')),
                  DataColumn(label: Text('Peso promedio')),
                  DataColumn(label: Text('Num. Lote')),
                  DataColumn(label: Text('ID de param. 1 ')),
                ],
                source: RegistroRacimoDataSource(context))
          ],
        ),
      ),
    );
  }
}
