import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'package:admin_dashboard/models/costos.dart';
import 'package:admin_dashboard/models/parametrizacion.dart';

import 'package:admin_dashboard/datatables/siembra_datasource.dart';
import 'package:admin_dashboard/datatables/registro_racimo_datasource.dart';

class PlaningTableReport extends StatefulWidget {
  final String nombreReporte; // Parámetro de clase

  const PlaningTableReport({Key? key, required this.nombreReporte})
      : super(key: key);

  @override
  State<PlaningTableReport> createState() => _PlaningTableReportState();
}

class _PlaningTableReportState extends State<PlaningTableReport> {
  int c = 0;
  final TextEditingController sowingDateController = TextEditingController();
  DateTime? selectedStartDate;
  final TextEditingController sowingDateEndController = TextEditingController();
  /*TextEditingController initialDateController = TextEditingController();
  TextEditingController finalDateController = TextEditingController();*/
  late UsersProvider usersProvider; // Declaración de usersProvider

  @override
  void initState() {
    super.initState();
    usersProvider = Provider.of<UsersProvider>(context, listen: false);
  }

  // La función para filtrar los datos usando las fechas con el formato 'MMM d, y'
  void filtrarPorRangoFechas(String initialDateText, String finalDateText) {
    try {
      // Parsear las fechas utilizando el formato 'MM/d/yyyy' (mes/día/año)
      DateTime fechaInicioSeleccionada =
          DateFormat('MM/d/yyyy').parse(initialDateText);
      DateTime fechaFinSeleccionada =
          DateFormat('MM/d/yyyy').parse(finalDateText);

      print('fechas ${fechaInicioSeleccionada} y ${fechaFinSeleccionada}');

      // Filtrar los datos según el rango de fechas
      List<Parametrizacion> datosFiltrados =
          usersProvider.parametrizacion.where((element) {
        return (element.sowingDate.isAtSameMomentAs(fechaInicioSeleccionada) || element.sowingDate.isAfter(fechaInicioSeleccionada))
        && (element.sowingDateEnd.isAtSameMomentAs(fechaFinSeleccionada) || element.sowingDateEnd.isBefore(fechaFinSeleccionada));
      }).toList();

      // Notificar a los widgets que los datos han cambiado
      setState(() {
        usersProvider.parametrizacion = datosFiltrados;
      });
    } catch (e) {
      // Manejar el error de formato de fecha inválido aquí
      print('Error al parsear la fecha: $e');
      // Puedes mostrar un mensaje al usuario o realizar alguna otra acción para manejar el error.
    }
  }

  @override
  Widget build(BuildContext context) {
    final parametrizacionDataSource =
        SiembraDataSource(usersProvider.parametrizacion, this.context, true);
    final parametrizacion2DataSource = RegistroRacimoDataSource(
        usersProvider.parametrizacion, this.context, true);

    final costos = usersProvider.costos;

    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Container(
                width: MediaQuery.of(context).size.width *
                    0.4, // Ajusta el ancho del contenedor según tus necesidades
                child: IconButton(
                    onPressed: () {
                      generateAndDownloadPdfSiembra(
                          usersProvider.parametrizacion, costos);
                    },
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                      size: 35,
                    ))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: PaginatedDataTable(
            columnSpacing: 10,
            sortAscending: usersProvider.ascending,
            sortColumnIndex: usersProvider.sortColumnIndex,
            header: const Center(
                child: Text(
              "Siembra",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            headingRowHeight: 130,
            columns: const [
              DataColumn(tooltip: "ID", label: Text('ID')),
              DataColumn(
                  tooltip: "Condición climática",
                  label: Text('Cond. Climática')),
              DataColumn(
                  tooltip: "Variedad del banano", label: Text('Var. Banano')),
              DataColumn(
                  tooltip: "Cantidad del pesticida",
                  label: Text('Cant. pesticida')),
              DataColumn(
                  tooltip: "Cantidad del fertilizante",
                  label: Text('Cant. fertilizante')),
              DataColumn(
                  tooltip: "Nombre de la semilla", label: Text('N. semillas')),
              DataColumn(
                  tooltip: "Fecha de fumigación",
                  label: Text('Fecha fumigación')),
              DataColumn(tooltip: "Riego", label: Text('Riego')),
            ],
            source: parametrizacionDataSource,
            onPageChanged: (page) {},
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Text(
          'Filtrar por fecha',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            const Flexible(
                child: Text(
              'Fecha inicial',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            )),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Container(
                width: 100,
                child: TextField(
                  controller: sowingDateController,
                  decoration:
                      const InputDecoration(labelText: 'Fecha de inicio'),
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          sowingDateController.text =
                              DateFormat.yMd().format(selectedDate);
                          selectedStartDate = selectedDate;
                          filtrarPorRangoFechas(
                            sowingDateController.text,
                            sowingDateEndController.text,
                          );
                        });
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            const Flexible(
                child: Text(
              'Fecha final',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            )),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Container(
                width: 100,
                child: TextField(
                  enabled: sowingDateController.text.isNotEmpty,
                  controller: sowingDateEndController,
                  decoration: const InputDecoration(labelText: 'Fecha de fin'),
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: selectedStartDate ?? DateTime.now(),
                      firstDate: selectedStartDate ?? DateTime.now(),
                      lastDate: DateTime(2030),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          sowingDateEndController.text =
                              DateFormat.yMd().format(selectedDate);
                          filtrarPorRangoFechas(
                            sowingDateController.text,
                            sowingDateEndController.text,
                          );
                        });
                      }
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
                child: Container(
              width: 50, // Ancho del contenedor
              height: 50, // Altura del contenedor
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  usersProvider.getSiembra();
                  sowingDateController
                      .clear(); // Esto limpia el texto del TextField
                  sowingDateEndController.clear();
                },
                icon: Transform.rotate(
                  angle:
                      180 * 3.141592653589793 / 180, // Rotación de 180 grados
                  child: Icon(
                    Icons
                        .autorenew, // Ícono de actualización (puede reemplazar con otro ícono de flecha)
                    color: Colors.black, // Color del ícono
                  ),
                ),
              ),
            ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: PaginatedDataTable(
            columnSpacing: 8,
            sortAscending: usersProvider.ascending,
            sortColumnIndex: usersProvider.sortColumnIndex,
            header: const Center(
                child: Text(
              "Registro racimo",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            headingRowHeight: 100,
            columns: const [
              DataColumn(tooltip: "Fecha Siembra", label: Text('Fecha Inicio')),
              DataColumn(tooltip: "Fecha Siembra", label: Text('Fecha Fin')),
              DataColumn(
                  tooltip: "Tiempo estimado", label: Text('Tiempo estimado')),
              DataColumn(
                  tooltip: "Número de racimos", label: Text('Núm. racimos')),
              DataColumn(
                  tooltip: "Número de racimos rechazados",
                  label: Text('Núm. rechazados')),
              DataColumn(
                  tooltip: "Peso promedio", label: Text('Peso promedio')),
              DataColumn(tooltip: "Número de lote", label: Text('Núm. Lote')),
              DataColumn(
                  tooltip: "ID parametrización 1",
                  label: Text('ID de param. 1')),
            ],
            source: parametrizacion2DataSource,
            onPageChanged: (page) {},
          ),
        ),
      ],
    );
  }
}

//Funciones
void generateAndDownloadPdfSiembra(
    List<Parametrizacion> parametrizacion, List<Costos> costos) async {
  final pdf = pw.Document();
  final ByteData imageLeftData =
      await rootBundle.load('assets/logo_pdfFruty.jpeg');
  final ByteData imageCenterData = await rootBundle.load('/seguimientoS.jpeg');
  final ByteData imageRightData = await rootBundle.load('/logo_pdfImagen.jpeg');

  final Uint8List imageLeftBytes = imageLeftData.buffer.asUint8List();
  final Uint8List imageCenterBytes = imageCenterData.buffer.asUint8List();
  final Uint8List imageRightBytes = imageRightData.buffer.asUint8List();

  // Crear las imágenes
  final pdfImageLeft = pw.MemoryImage(imageLeftBytes);
  final pdfImageCenter = pw.MemoryImage(imageCenterBytes);
  final pdfImageRight = pw.MemoryImage(imageRightBytes);

  // Crear la tabla de permisos
  final permisosTable = pw.Table(
    border: pw.TableBorder.all(),
    children: [
      pw.TableRow(
        children: [
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('ID',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Condición climatica',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Variación del Banano',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Cantidad de semillas',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Cantidad de pesticida',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Cantidad de fertilizante',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Fecha fumigación',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Riego',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),
      ...parametrizacion.map((parametrizaci) {
        return pw.TableRow(
          children: [
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.id.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.climaticCondition,
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.bananaVariety,
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.seedName.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.pesticideQuantityKG.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.fertilizerQuantityKG.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.fumigationDate.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.irrigation.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
          ],
        );
      }),
    ],
  );

  // Crear la tabla de usuarios
  final usuariosTable = pw.Table(
    border: pw.TableBorder.all(),
    children: [
      pw.TableRow(
        children: [
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Fecha Inicio',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Fecha fin',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Tiempo estimado',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Núm. Racimos ',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Núm. Rechazados',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Peso promedio',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Núm de lote',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Id parametrización I',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),
      ...parametrizacion.map((parametrizaci) {
        return pw.TableRow(
          children: [
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.sowingDate.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.sowingDateEnd.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.estimatedSowingTime.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.numberOfBunches.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.rejectedBunches.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.averageBunchWeight.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.batchNumber.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(parametrizaci.id.toString(),
                  style: pw.TextStyle(fontSize: 10)),
            ),
          ],
        );
      }),
    ],
  );

  // Agregar las tablas al documento PDF
  pdf.addPage(
    pw.MultiPage(
      header: (pw.Context context) {
        return pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Image(pdfImageLeft, width: 100, height: 100),
            pw.Image(pdfImageCenter, width: 200, height: 150),
            pw.Image(pdfImageRight, width: 100, height: 100),
          ],
        );
      },
      footer: (pw.Context context) {
        return pw.Align(
          alignment: pw.Alignment.centerRight,
          child: pw.Text(
              'Página ${context.pageNumber} de ${context.pagesCount}',
              style: pw.TextStyle(fontSize: 12)),
        );
      },
      build: (pw.Context context) {
        return [
          // Reemplaza "yourLeftImageProvider" con la imagen de la esquina izquierda

          pw.Text('Informe de Parametrización',
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.Text('Siembra',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          permisosTable,
          pw.SizedBox(height: 20),
          pw.Text('Registro de racimos',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          usuariosTable,
        ];
      },
    ),
  );

  final Uint8List bytes = await pdf.save();

  // Descargar el archivo PDF
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  final anchor = html.document.createElement('a') as html.AnchorElement
    ..href = url
    ..style.display = 'none'
    ..download = 'InformeSiembra.pdf';

  html.document.body?.children.add(anchor);
  anchor.click();

  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
