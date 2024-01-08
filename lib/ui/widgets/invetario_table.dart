import 'package:admin_dashboard/ui/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    List<String> medida = ["LITRO", "GALON", "NINGUNO", "FUNDAS", "SACOS"];
    String selectedMedida = "LITRO";

    final TextEditingController codigoController = TextEditingController();
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
                                      inputFormatters: <TextInputFormatter>[
                                        // for below version 2 use this
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'^[a-zA-Z\s]+$')),
                                      ],
                                      controller: productoController,
                                      decoration:
                                          InputDecoration(labelText: 'Nombre'),
                                    ),
                                    TextField(
                                      controller: codigoController,
                                      decoration:
                                          InputDecoration(labelText: 'Codigo'),
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
                                      maxLength: 100,
                                      decoration: InputDecoration(
                                          labelText: 'Descripcion'),
                                    ),
                                    DropdownButtonFormField<String>(
                                        value: selectedMedida,
                                        decoration: const InputDecoration(
                                            labelText: 'Unidad/medida'),
                                        items: medida.map((option) {
                                          return DropdownMenuItem<String>(
                                            value: option,
                                            child: Text(option),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedMedida = value!;
                                          });
                                        }),
                                    TextField(
                                      controller: cantidadController,
                                      decoration: InputDecoration(
                                          labelText: 'Cantidad'),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        // for below version 2 use this
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),

                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                    ),
                                    TextField(
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(
                                            r'^\d+[\.]?\d{0,2}')), // Permite números decimales con punto o coma como separador
                                      ],
                                      controller: precioController,
                                      decoration: const InputDecoration(
                                        labelText: 'Precio',
                                        hintText: '\$',
                                      ),
                                      keyboardType: const TextInputType
                                          .numberWithOptions(
                                          decimal:
                                              true), // Habilita el teclado numérico con opción decimal
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
                                      final codigo = codigoController.text;
                                      final medida = selectedMedida;
                                      final cantidad =
                                          int.tryParse(cantidadController.text);
                                      final precio = double.tryParse(
                                          precioController.text);
                                      final productoname =
                                          productoController.text;
                                      final productdescription =
                                          descripcionController.text;
                                      final fecha = fechaController.text;
                                      // ignore: unnecessary_null_comparison
                                      if (productoname == null ||
                                          productoname == "" ||

                                          // ignore: unnecessary_null_comparison
                                          codigo == null ||
                                          codigo == "" ||
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
                                          codigo,
                                          productoname,
                                          productdescription,
                                          medida,
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
                  "Insumos",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
                headingRowHeight: 100,
                columns: const [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Codigo')),
                  DataColumn(label: Text('Producto')),
                  DataColumn(label: Text('Descripción')),
                  DataColumn(label: Text('Unidad/Medida')),
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
