import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:admin_dashboard/providers/users_provider.dart';

import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'package:admin_dashboard/models/costos.dart';
import 'package:admin_dashboard/models/inventario.dart';

import 'package:admin_dashboard/datatables/inventario_datasource.dart';

class InvetoryTableReport extends StatefulWidget {
  final String nombreReporte; // Parámetro de clase

  const InvetoryTableReport({Key? key, required this.nombreReporte})
      : super(key: key);

  @override
  State<InvetoryTableReport> createState() => _InvetoryTableReportState();
}

class _InvetoryTableReportState extends State<InvetoryTableReport> {
  int c = 0;
  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final inventario = usersProvider.inventario;
    final costos = usersProvider.costos;

    final inventarioDataSource =
        new InventarioDataSource(inventario, this.context, true);

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
                      generateAndDownloadPdfInventario(inventario, costos);
                    },
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                      size: 35,
                    ))),
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
                  decoration: const InputDecoration(
                    labelText: 'Fecha de inicio:',
                  ),
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {});
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
                  decoration: const InputDecoration(
                    labelText: 'Fecha final',
                  ),
                  readOnly: true,
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {});
                      }
                    });
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: PaginatedDataTable(
            sortAscending: usersProvider.ascending,
            sortColumnIndex: usersProvider.sortColumnIndex,
            header: const Center(
                child: Text(
              "Inventario",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            )),
            headingRowHeight: 100,
            columns: const [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Descripcion')),
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Fecha de compra')),
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Precio')),
            ],
            source: inventarioDataSource,
            onPageChanged: (page) {},
          ),
        ),
      ],
    );
  }
}

void generateAndDownloadPdfInventario(
    List<Inventario> inventario, List<Costos> costos) async {
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
            child: pw.Text('Descripción',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Producto',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Cantidad',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Precio',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Fecha',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),
      ...inventario.map((inventario) {
        return pw.TableRow(
          children: [
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                inventario.id.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                inventario.description,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                inventario.product,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                inventario.unitPrice.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                inventario.quantity.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                inventario.purchaseDate.toString(),
                style: pw.TextStyle(fontSize: 10),
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
          pw.Text('Tabla de Inventario',
              style:
                  pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          permisosTable,
          pw.SizedBox(height: 20),
          pw.Text('Tabla de Costos',
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
    ..download = 'InformeInventario.pdf';

  html.document.body?.children.add(anchor);
  anchor.click();

  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
