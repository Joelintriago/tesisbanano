import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'package:admin_dashboard/models/costos.dart';
import 'package:admin_dashboard/models/rentabilidad.dart';

import 'package:provider/provider.dart';
import 'package:admin_dashboard/providers/users_provider.dart';

import 'package:admin_dashboard/datatables/rentabilidad_datasource.dart';

class CostosTableReport extends StatefulWidget {
  final String nombreReporte; // Parámetro de clase

  const CostosTableReport({Key? key, required this.nombreReporte})
      : super(key: key);

  @override
  State<CostosTableReport> createState() => _CostosTableReportState();
}

class _CostosTableReportState extends State<CostosTableReport> {
  int c = 0;
  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);

    final rentabilidad = usersProvider.rentabilidad;
    final costos = usersProvider.costos;
    final rentabilidadDataSource = RentabilidadDataSource(rentabilidad,
        this.context, costos, usersProvider.parametrizacion, true);

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
                      generateAndDownloadPdfRentCosto(rentabilidad, costos);
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
            header: const Center(
                child: Text(
              "Rentabilidad",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            headingRowHeight: 100,
            columnSpacing: 5,
            columns: const [
              //DataColumn(label: Text('Id')),

              DataColumn(tooltip: "Id", label: Text('Id')),
              DataColumn(tooltip: "Número de lote", label: Text('Núm. lote')),
              DataColumn(
                  tooltip: "Número Racimos aceptados",
                  label: Text('Núm. Racimos aceptados')),
              DataColumn(
                  tooltip: "Peso estimado por Racimo",
                  label: Text('Peso estimado')),
              DataColumn(
                  tooltip: "Conversión de KG a LB", label: Text('Conversión')),

              DataColumn(tooltip: "Rentabilidad", label: Text('Rentabilidad')),
            ],
            source: rentabilidadDataSource,
            onPageChanged: (page) {},
          ),
        ),
      ],
    );
  }
}

//FUNCIONES
void generateAndDownloadPdfRentCosto(
    List<Rentabilidad> rentabilidad, List<Costos> costos) async {
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
            child: pw.Text('Número de lote',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Número de racimos aceptados',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Peso estimado por racimo',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Conversión',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Rentabilidad',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),

      // ... aquí puedes agregar las filas de datos de manera similar a lo que tenías antes ...
      ...rentabilidad.map((renta) {
        double rentabilidadValue = renta.planningSowing2.averageBunchWeight *
            (renta.planningSowing2.numberOfBunches -
                renta.planningSowing2.rejectedBunches) /
            1000;

        bool esRentable = rentabilidadValue >= 29;
        return pw.TableRow(
          children: [
            pw.Container(
             color: esRentable ? PdfColors.green100 : PdfColors.red100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                renta.id.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
             color: esRentable ? PdfColors.green100 : PdfColors.red100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                renta.planningSowing2.batchNumber.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: esRentable ? PdfColors.green100 : PdfColors.red100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                (renta.planningSowing2.numberOfBunches -
                        renta.planningSowing2.rejectedBunches)
                    .toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: esRentable ? PdfColors.green100 : PdfColors.red100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                ((renta.planningSowing2.averageBunchWeight *
                            (renta.planningSowing2.numberOfBunches -
                                renta.planningSowing2.rejectedBunches) /
                            1000))
                        .toStringAsFixed(2) +
                    "KG",
                style: pw.TextStyle(
                  fontSize: 10),
              ),
            ),
            pw.Container(
              color: esRentable ? PdfColors.green100 : PdfColors.red100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                // ignore: prefer_interpolation_to_compose_strings
                ((renta.planningSowing2.averageBunchWeight *
                                (renta.planningSowing2.numberOfBunches -
                                    renta.planningSowing2.rejectedBunches)) *
                            2.20 /
                            1000)
                        .toStringAsFixed(2) +
                    "LB",
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: esRentable ? PdfColors.green100 : PdfColors.red100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                esRentable ? "RENTABLE" : "NO RENTABLE",
                style: pw.TextStyle(
                  color: esRentable ? PdfColors.green : PdfColors.red,
                  fontSize: 10,
                ),
              ),
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
            child: pw.Text('ID',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Descripción',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Mano de obra',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Inventario id',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Combustible',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Insumos',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Planeación ID',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('total',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),
      ...costos.map((costo) {
        return pw.TableRow(
          children: [
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                costo.id.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                costo.description,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                costo.labor.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                costo.inventoryId.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                costo.fuel.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                costo.input.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                costo.id.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                costo.totalCosts.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
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
          pw.Text('Tabla de Rentabilidad',
              style:
                  pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          permisosTable,
          pw.SizedBox(height: 20),
          pw.Text('Tabla de costos',
              style:
                  pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
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
    ..download = 'InformeRentabilidadyCosto.pdf';

  html.document.body?.children.add(anchor);
  anchor.click();

  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
