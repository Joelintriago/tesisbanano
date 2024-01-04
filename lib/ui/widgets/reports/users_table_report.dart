import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:provider/provider.dart';

import 'package:universal_html/html.dart' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'package:admin_dashboard/datatables/permisso_datasource.dart';
import 'package:admin_dashboard/datatables/users_datasource.dart';

import 'package:admin_dashboard/models/permisos.dart';
import 'package:admin_dashboard/models/usuario.dart';

class UsersTableReport extends StatefulWidget {
  final String nombreReporte; // Parámetro de clase

  const UsersTableReport({Key? key, required this.nombreReporte})
      : super(key: key);

  @override
  State<UsersTableReport> createState() => _UsersTableReportState();
}

class _UsersTableReportState extends State<UsersTableReport> {
  int c = 0;
  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final permisosRol = usersProvider.permisosRol;
    final permisos = usersProvider.permisos;

    final usersDataSource =
        new UsersDataSource(usersProvider.users, this.context, true);
    final permisoDataSource =
        new PermisosDataSource(permisos, this.context, permisosRol, true);

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
                      generateAndDownloadPdfAdministracion(
                          permisos, usersProvider.users);
                    },
                    icon: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                      size: 35,
                    ))),
          ),
        ),
        PaginatedDataTable(
          sortAscending: usersProvider.ascending,
          sortColumnIndex: usersProvider.sortColumnIndex,
          header: Center(
              child: Text(
            widget.nombreReporte,
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
          headingRowHeight: 100,
          columns: [
            DataColumn(label: Text('Id'), numeric: true),
            DataColumn(
                label: Text('Nombre'),
                onSort: (colIndex, _) {
                  usersProvider.sortColumnIndex = colIndex;
                  usersProvider.sort<String>((user) => user.firstName);
                }),
            DataColumn(
                label: Text('Apellido'),
                onSort: (colIndex, _) {
                  usersProvider.sortColumnIndex = colIndex;
                  usersProvider.sort<String>((user) => user.lastName);
                }),
            DataColumn(
              label: Text('Email'),
            ),
            DataColumn(label: Text('Rol')),
            DataColumn(label: Text('Estado')),
          ],
          source: usersDataSource,
          onPageChanged: (page) {
            print('page: $page');
          },
        ),
        const SizedBox(
          height: 15,
        ),
        PaginatedDataTable(
          sortAscending: usersProvider.ascending,
          sortColumnIndex: usersProvider.sortColumnIndex,
          header: const Center(
              child: Text(
            "Permisos",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          )),
          headingRowHeight: 100,
          columns: const [
            DataColumn(label: Text('Id')),
            DataColumn(label: Text('Descripción')),
            DataColumn(label: Text('Permiso')),
          ],
          source: permisoDataSource,
          onPageChanged: (page) {},
        )
      ],
    );
  }
}

void generateAndDownloadPdfAdministracion(
    List<Permisos> permisos, List<Usuario> usuarios) async {
  final pdf = pw.Document();

  final ByteData imageLeftData =
      await rootBundle.load('assets/logo_pdfFruty.jpeg');
  final ByteData imageCenterData =
      await rootBundle.load('assets/seguimientoS.jpeg');
  final ByteData imageRightData =
      await rootBundle.load('assets/logo_pdfImagen.jpeg');

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
          pw.Text('ID',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          pw.Text('Descripción',
              style:
                  pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        ],
      ),
      ...permisos.map((permiso) {
        return pw.TableRow(
          children: [
            pw.Text(permiso.id.toString()),
            pw.Text(permiso.description),
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
            color: PdfColors.green300, // Color de fondo para el título 'ID'
            alignment: pw.Alignment.center,
            child: pw.Text('ID',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Nombre',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Apellido',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Correo Electrónico',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Estado',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
          pw.Container(
            color: PdfColors.green300,
            alignment: pw.Alignment.center,
            child: pw.Text('Rol',
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
          ),
        ],
      ),
      ...usuarios.map((usuario) {
        return pw.TableRow(
          children: [
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                usuario.id.toString(),
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                usuario.firstName,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                usuario.lastName,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                usuario.email,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                usuario.state,
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
            pw.Container(
              color: PdfColors.green100,
              alignment: pw.Alignment.center,
              child: pw.Text(
                usuario.roles[0].roleName,
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
          pw.Text('Tabla de Permisos',
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          permisosTable,
          pw.SizedBox(height: 20),
          pw.Text('Tabla de Usuarios',
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
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
    ..download = 'InformeAdministracion.pdf';

  html.document.body?.children.add(anchor);
  anchor.click();

  html.document.body?.children.remove(anchor);
  html.Url.revokeObjectUrl(url);
}
