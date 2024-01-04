import 'package:admin_dashboard/models/inventario.dart';
import 'package:admin_dashboard/ui/buttons/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

import 'package:provider/provider.dart';
import 'package:admin_dashboard/providers/users_provider.dart';

import 'package:admin_dashboard/datatables/costos_datasource.dart';

import 'package:admin_dashboard/services/notification_service.dart';

class CostosView extends StatefulWidget {
  @override
  State<CostosView> createState() => _CostosViewState();
}

class _CostosViewState extends State<CostosView> {
  int c = 0;
  int? selectedInventarioId;

  @override
  @override
  void didChangeDependencies() {
    if (c == 0) {
      super.didChangeDependencies();
      Provider.of<UsersProvider>(context).getCostos();
      Provider.of<UsersProvider>(context).getInventario();
      Provider.of<UsersProvider>(context).getSiembra();
      c++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Inventario objetoInventario;
    final usersProvider = Provider.of<UsersProvider>(context);

    List<String> inventarioNombres =
        usersProvider.inventario.map((item) => item.product).toList();
    List<Inventario> invent = usersProvider.inventario.toList();
    List<String> selectedInventario = [];
    List<Inventario> selectedItems = [];
    double sumaTotal = 0.0;

    final costos = usersProvider.costos;
    final inventario = usersProvider.inventario;
    final planeacion = usersProvider.parametrizacion;
    final usersDataSource =
        CostosDataSource(costos, this.context, inventario, planeacion, false);
    final TextEditingController descriptionController = TextEditingController();

    final TextEditingController manoObraController = TextEditingController();
    final TextEditingController combustibleController = TextEditingController();

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
                                title: Text('Agregar Costo'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: descriptionController,
                                        decoration: InputDecoration(
                                            labelText: 'Descripción'),
                                      ),
                                      TextField(
                                        controller: manoObraController,
                                        decoration: const InputDecoration(
                                            labelText: 'Costo mano de obra',
                                            hintText: '\$'),
                                        keyboardType: TextInputType.number,
                                      ),
                                      TextField(
                                        controller: combustibleController,
                                        decoration: const InputDecoration(
                                            labelText: 'Costo Combustible',
                                            hintText: '\$'),
                                        keyboardType: TextInputType.number,
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
                                                  selectedItem.unitPrice * selectedItem.quantity;
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
                                    ],
                                  ),
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
                                      invent.forEach((element) {
                                        print(
                                            'Cantidad: ${element.quantity}, Precio: ${element.unitPrice}');
                                        // Puedes hacer lo que necesites con los datos, como mostrarlos en una interfaz de usuario
                                      });

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
                                        return;
                                      }
                                      if(sumaTotal == 0){
                                        NotificationsService.showSnackBarError('Seleccione almenos un insumo');
                                        return;
                                      }

                                      // Actualizar el inventario
                                      //  inventario.product = productoController.text;
                                      // inventario.purchaseDate = DateFormat.yMd().parse(fechaController.text);
                                      //inventario.quantity = cantidad;
                                      //inventario.unitPrice = precio;

                                      // Guardar cambios
                                      final total = manoO + combustible;
                                      await usersProvider.postCreateCosto(
                                          description,
                                          manoO,
                                          combustible,
                                          sumaTotal,
                                          total);
                                      // NotificationsService.showSnackbar('Producto agregado al inventario');
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
                  "Costos",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
                headingRowHeight: 100,
                columnSpacing: 5,
                columns: const [
                  //DataColumn(label: Text('Id')),

                  DataColumn(
                      tooltip: "Descripción", label: Text('Descripción')),
                  DataColumn(
                      tooltip: "Mano de obra", label: Text('Mano de obra')),
                  DataColumn(tooltip: "Insumo", label: Text('Insumo')),
                  DataColumn(
                      tooltip: "Combustible", label: Text('Combustible')),
                  DataColumn(tooltip: "Fecha", label: Text('Fecha')),
                  DataColumn(tooltip: "Total", label: Text('Total')),

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
