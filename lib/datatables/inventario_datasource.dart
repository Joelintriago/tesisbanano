import 'package:admin_dashboard/models/inventario.dart';
import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:admin_dashboard/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class InventarioDataSource extends DataTableSource {
  final List<Inventario> inventarios;
  final BuildContext context;
  final bool report;
  InventarioDataSource(this.inventarios, this.context, this.report);

  @override
  DataRow getRow(int index) {
    final Inventario inventario = inventarios[index];

    List<String> medida = ["LITRO", "GALON","NINGUNO","FUNDAS","SACOS"];
    String selectedMedida = inventario.medida;

    final TextEditingController codigoController = TextEditingController();
    final TextEditingController productoController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController fechaController = TextEditingController();
    final TextEditingController cantidadController = TextEditingController();
    final TextEditingController precioController = TextEditingController();

    codigoController.text = inventario.codigo;
    productoController.text = inventario.product;
    descripcionController.text = inventario.description;
    fechaController.text = DateFormat.yMd().format(inventario.purchaseDate);
    cantidadController.text = inventario.quantity.toString();
    precioController.text = inventario.unitPrice.toString();

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(inventario.id.toString())),
        DataCell(Text(inventario.codigo)),
        DataCell(Text(inventario.product)),
        DataCell(Text(inventario.description)),
        DataCell(Text(inventario.medida)),
        DataCell(Text(DateFormat('MMM d, y').format(inventario.purchaseDate))),
        DataCell(Text(inventario.quantity.toString())),
        DataCell(Text('\$${inventario.unitPrice.toString()}')),
        if (report != true)
          DataCell(
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                    final usersProvider =
                        Provider.of<UsersProvider>(context, listen: false);
                    await usersProvider.getRoles();
                    if (usersProvider.roles.isEmpty) return;

                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext dialogContext) {
                        return StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return SingleChildScrollView(
                              child: AlertDialog(
                                title: Text('Modificar producto'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
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
                                          initialDate: inventario.purchaseDate,
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
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
                                        // for below version 2 use this
                                        FilteringTextInputFormatter.allow(
                                            RegExp(r'[0-9]')),

                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      controller: precioController,
                                      decoration: InputDecoration(
                                          labelText: 'Precio', hintText: '\$'),
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
                                      final codigo = codigoController.text;
                                      final medida = selectedMedida;
                                      final cantidad =
                                          int.tryParse(cantidadController.text);
                                      final precio = double.tryParse(
                                          precioController.text);
                                      final productdescription =
                                          descripcionController.text;
                                      final productoname =
                                          productoController.text;
                                      final fecha = fechaController.text;
                                      // ignore: unnecessary_null_comparison
                                      if (productoname == null ||
                                          productoname == "" ||
                                          productdescription == null ||
                                          productdescription == "" ||
                                          // ignore: unnecessary_null_comparison
                                          codigo == null ||
                                          codigo == " "
                                          // ignore: unnecessary_null_comparison
                                          ||
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
                                      await usersProvider.putUpdateInventario(
                                          codigo,
                                          productoname,
                                          productdescription,
                                          medida,
                                          fecha,
                                          precio,
                                          cantidad,
                                          inventario.id);

                                      Navigator.pop(context);
                                    },
                                    child: Text('Guardar'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final dialog = AlertDialog(
                      title: const Text('Eliminar inventario'),
                      content: const Text('¿Desea eliminar el registro?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar')),
                        ElevatedButton(
                            onPressed: () async {
                              final usersProvider = Provider.of<UsersProvider>(
                                  context,
                                  listen: false);
                              await usersProvider
                                  .deleteInventario(inventario.id);
                              Navigator.pop(context);
                            },
                            child: const Text('Eliminar')),
                      ],
                    );
                    showDialog(context: context, builder: (_) => dialog);
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
  int get rowCount => this.inventarios.length;

  @override
  int get selectedRowCount => 0;
}
