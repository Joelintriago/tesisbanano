import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:admin_dashboard/models/costos.dart';
import 'package:admin_dashboard/models/inventario.dart';
import 'package:admin_dashboard/models/parametrizacion.dart';
import 'package:multiselect/multiselect.dart';

import 'package:provider/provider.dart';
import 'package:admin_dashboard/providers/users_provider.dart';

import 'package:admin_dashboard/services/notification_service.dart';

class CostosDataSource extends DataTableSource {
  final List<Costos> costos;
  final List<Inventario> inventario;
  final List<Parametrizacion> planeacion;
  final BuildContext context;
  final bool reporte;
  CostosDataSource(this.costos, this.context, this.inventario, this.planeacion,
      this.reporte);

  @override
  DataRow getRow(int index) {
    final Costos costo = costos[index];

    final TextEditingController descriptionController = TextEditingController();

    final TextEditingController manoObraController = TextEditingController();
    final TextEditingController combustibleController = TextEditingController();

    descriptionController.text = costo.description;
    combustibleController.text = costo.fuel.toString();

    final usersProvider = Provider.of<UsersProvider>(context);

    List<String> inventarioNombres =
        usersProvider.inventario.map((item) => item.product).toList();
    List<Inventario> invent = usersProvider.inventario.toList();
    List<String> selectedInventario = [];
    List<Inventario> selectedItems = [];
    double sumaTotal = 0.0;

    manoObraController.text = costo.labor.toString();

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(costo.description)),
        DataCell(Text('\$${costo.labor.toString()}')),
        DataCell(Text('\$${costo.input.toString()}')),
        DataCell(Text('\$${costo.fuel.toString()}')),
        DataCell(Text(DateFormat('MMM d, y').format(costo.registerDate))),
        DataCell(Text('\$${costo.totalCosts.toString()}')),
        if (reporte != true)
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
                                      controller: descriptionController,
                                      decoration: InputDecoration(
                                          labelText: 'Descripción'),
                                    ),
                                    TextField(
                                       inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(
                                            r'^\d+[\.]?\d{0,2}')), // Permite números decimales con punto o coma como separador
                                      ],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      controller: manoObraController,
                                      decoration: InputDecoration(
                                          labelText: 'Costo mano de obra'),
                                    ),
                                    TextField(
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(
                                            r'^\d+[\.]?\d{0,2}')), // Permite números decimales con punto o coma como separador
                                      ],
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      controller: combustibleController,
                                      decoration: InputDecoration(
                                          labelText: 'Costo Combustible'),
                                    ),
                                    DropDownMultiSelect(
                                      options: inventarioNombres,
                                      selectedValues: selectedInventario,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedInventario = value.cast<
                                              String>(); // Actualiza la lista de nombres seleccionados
                                        });

                                        selectedItems.clear();
                                        sumaTotal =
                                            0.0; // Reinicia la suma total al cambiar la selección

                                        for (var name in value) {
                                          Inventario selectedItem =
                                              invent.firstWhere(
                                            (item) => item.product == name,
                                            orElse: () => Inventario(
                                              id: -1,
                                              codigo: '',
                                              purchaseDate: DateTime.now(),
                                              description: '',
                                              medida: '',
                                              product: '',
                                              quantity: 0,
                                              unitPrice: 0.0,
                                            ),
                                          );
                                          selectedItems.add(selectedItem);

                                          if (selectedItem.id != -1) {
                                            // Se encontró un elemento correspondiente al nombre seleccionado
                                            sumaTotal +=
                                                selectedItem.unitPrice *
                                                    selectedItem.quantity;
                                          } else {
                                            // Manejar el caso en el que no se encontró el elemento correspondiente al nombre seleccionado
                                            print(
                                                'No se encontró un elemento correspondiente al nombre seleccionado');
                                          }
                                        }

                                        print(
                                            'Has seleccionado $selectedInventario');
                                        print('Suma total: $sumaTotal');
                                      },
                                      whenEmpty: 'Seleccionar insumos',
                                    ),
                                    //Agregar nuevo select
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

                                      final manoO = double.tryParse(
                                          manoObraController.text);
                                      final combustible = double.tryParse(
                                          combustibleController.text);
                                      final description =
                                          descriptionController.text;

                                      // ignore: unnecessary_null_comparison
                                      if (description == null ||
                                          description == "") {
                                        NotificationsService.showSnackBarError(
                                            'campos incorrectos');
                                        return;
                                      }
                                      if (manoO == null ||
                                          manoO <= 0 ||
                                          combustible == null ||
                                          combustible <= 0) {
                                        NotificationsService.showSnackBarError(
                                            'Cantidades inválidos');

                                        if (sumaTotal == 0) {
                                          NotificationsService.showSnackBarError(
                                              'Seleccione almenos un insumo');
                                          return;
                                        }
                                        return;
                                      }

                                      // Actualizar el inventario
                                      //  inventario.product = productoController.text;
                                      // inventario.purchaseDate = DateFormat.yMd().parse(fechaController.text);
                                      //inventario.quantity = cantidad;
                                      //inventario.unitPrice = precio;

                                      // Guardar cambios
                                      final total = manoO + combustible;
                                      await usersProvider.putUpdateCostos(
                                          description,
                                          manoO,
                                          combustible,
                                          sumaTotal,
                                          total,
                                          costo.id);
                                      NotificationsService.showSnackBar(
                                          'Costo actualizado');
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
                      title: const Text('Eliminar costo'),
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
                              await usersProvider.deleteCostos(costo.id);

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
  int get rowCount => this.costos.length;

  @override
  int get selectedRowCount => 0;
}
