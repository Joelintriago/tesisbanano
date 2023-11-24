import 'package:admin_dashboard/ui/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:admin_dashboard/datatables/inventario_datasource.dart';

import 'package:admin_dashboard/services/notification_service.dart';

import 'package:provider/provider.dart';
import 'package:admin_dashboard/providers/users_provider.dart';

class InventarioView extends StatefulWidget {
  @override
  State<InventarioView> createState() => _InventarioViewState();
}

class _InventarioViewState extends State<InventarioView> {
  int c = 0;
  @override
  @override
  void didChangeDependencies() {
    if (c == 0) {
      super.didChangeDependencies();
      Provider.of<UsersProvider>(context).getInventario();

      c++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context);
    final inventario = usersProvider.inventario;
    final usersDataSource =
        new InventarioDataSource(inventario, this.context, false);
    final TextEditingController productoController = TextEditingController();
    final TextEditingController fechaController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController precioController = TextEditingController();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Card(
        elevation: 10,
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: PaginatedDataTable(
                sortAscending: usersProvider.ascending,
                sortColumnIndex: usersProvider.sortColumnIndex,
                actions: [
                  CustomIconButton(
                    text: 'Agregar',
                    icon: Icons.add_outlined,
                    onPressed: () async {
                      final usersProvider =
                          Provider.of<UsersProvider>(context, listen: false);

                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                title: Text('Agregar producto'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      controller: productoController,
                                      decoration:
                                          InputDecoration(labelText: 'Nombre'),
                                    ),
                                    TextField(
                                      controller: fechaController,
                                      decoration:
                                          InputDecoration(labelText: 'Fecha'),
                                      readOnly: true,
                                      onTap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2030),
                                        ).then((selectedDate) {
                                          if (selectedDate != null) {
                                            setState(() {
                                              fechaController.text =
                                                  DateFormat.yMd()
                                                      .format(selectedDate);
                                            });
                                          }
                                        });
                                      },
                                    ),
                                    TextField(
                                      controller: descripcionController,
                                      decoration: InputDecoration(
                                          labelText: 'Descripcion'),
                                    ),
                                    TextField(
                                      controller: cantidadController,
                                      decoration: InputDecoration(
                                          labelText: 'Cantidad'),
                                      keyboardType: TextInputType.number,
                                    ),
                                    TextField(
                                      controller: precioController,
                                      decoration:
                                          InputDecoration(labelText: 'Precio',
                                          hintText: '\$'),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // Validar cantidad y precio
                                      final cantidad =
                                          int.tryParse(cantidadController.text);
                                      final precio = double.tryParse(
                                          precioController.text);
                                      final productoname =
                                          productoController.text;
                                      final productdescription = descripcionController.text;
                                      final fecha = fechaController.text;
                                      // ignore: unnecessary_null_comparison
                                      if (productoname == null ||
                                          productoname == "" ||
                                          // ignore: unnecessary_null_comparison
                                          productdescription == null ||
                                          productdescription == "" ||
                                          // ignore: unnecessary_null_comparison
                                          fecha == null ||
                                          fecha == "") {
                                        NotificationsService.showSnackBarError(
                                            'Campos incorrectos');
                                        return;
                                      }
                                      if (cantidad == null ||
                                          cantidad <= 0 ||
                                          precio == null ||
                                          precio <= 0) {
                                        NotificationsService.showSnackBarError(
                                            'Cantidad y precio inválidos');
                                        return;
                                      }

                                      // Actualizar el inventario
                                      //  inventario.product = productoController.text;
                                      // inventario.purchaseDate = DateFormat.yMd().parse(fechaController.text);
                                      //inventario.quantity = cantidad;
                                      //inventario.unitPrice = precio;

                                      // Guardar cambios
                                      print(fecha);
                                      await usersProvider.postCreateInventario(
                                          productoname,
                                          productdescription,
                                          fecha,
                                          precio,
                                          cantidad);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Guardar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
                header: const Center(
                    child: Text(
                  "Inventario de insumos",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
                headingRowHeight: 100,
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Producto')),
                  DataColumn(label: Text('Descripción')),
                  DataColumn(label: Text('Fecha de compra')),
                  DataColumn(label: Text('Cantidad')),
                  DataColumn(label: Text('Precio')),
                  DataColumn(label: Text('Acciones')),
                ],
                source: usersDataSource,
                onPageChanged: (page) {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
