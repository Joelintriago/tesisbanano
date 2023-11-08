import 'package:flutter/material.dart';

import 'package:admin_dashboard/models/usuario.dart';
import 'package:admin_dashboard/models/roles.dart';

import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:provider/provider.dart';

import '../services/notification_service.dart';

class UsersDataSource extends DataTableSource {
  final List<Usuario> users;
  final BuildContext context;

  UsersDataSource(this.users, this.context);
  

  @override
  DataRow? getRow(int index) {
    final Usuario user = users[index];

    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(user.id.toString())),
      DataCell(Text(user.firstName)),
      DataCell(Text(user.lastName)),
      DataCell(Text(user.email)),
      DataCell(Text(user.roles[0].roleName)),
      DataCell(
        user.state == "inactivo"
            ? const Icon(Icons.clear, color: Colors.red) // Muestra una x roja
            : const Icon(Icons.check,
                color: Colors.green), // Muestra un visto verde
      ),
      DataCell(Row(
        children: [
          IconButton(
              onPressed: () async {
                final usersProvider =
                    Provider.of<UsersProvider>(context, listen: false);
                await usersProvider.getRoles();
                if (usersProvider.roles.isEmpty) return;
                final TextEditingController nameController =
                    TextEditingController();
                final TextEditingController emailController =
                    TextEditingController();
                final TextEditingController lastNameController =
                    TextEditingController();
                String? selectedStatus;
                int? selectedRoleId;
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          nameController.text = user.firstName;
                          lastNameController.text = user.lastName;
                          emailController.text = user.email;

                          // Asignar el estado y el rol seleccionados
                          selectedStatus = user.state;
                          selectedRoleId = user.roles[0].id;
                          late Roles rol;
                          for (Roles role in usersProvider.roles) {
                            if (user.roles[0].roleName == role.roleName) {
                              rol = role;
                              break; // Si se encuentra una coincidencia, se detiene el bucle
                            }
                          }

                          return SingleChildScrollView(
                            child: AlertDialog(
                              title: const Text('Editar usuario'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: nameController,
                                    decoration:
                                        InputDecoration(labelText: 'Nombre'),
                                  ),
                                  TextField(
                                    controller: lastNameController,
                                    decoration:
                                        InputDecoration(labelText: 'Apellido'),
                                  ),
                                  DropdownButtonFormField<String>(
                                    value: selectedStatus,
                                    decoration:
                                        InputDecoration(labelText: 'Estado'),
                                    items: ['activo', 'inactivo']
                                        .map<DropdownMenuItem<String>>(
                                          (String value) =>
                                              DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (String? value) {
                                      selectedStatus = value;
                                    },
                                  ),
                                  DropdownButtonFormField<Roles>(
                                    value: rol,
                                    decoration: InputDecoration(labelText: 'Rol'),
                                    items: usersProvider.roles
                                        .map<DropdownMenuItem<Roles>>(
                                          (Roles rol) => DropdownMenuItem<Roles>(
                                            value: rol,
                                            child: Text(rol.roleName),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (Roles? value) {
                                      selectedRoleId = value?.id;
                                    },
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    // Lógica para guardar el usuario utilizando los datos ingresados
                                    final String name = nameController.text;
                                    final String lastName =
                                        lastNameController.text;
                            
                                    final String email = emailController.text;
                            
                                    // Validar que todos los campos estén completos
                                    if (email.isEmpty ||
                                        name.isEmpty ||
                                        lastName.isEmpty ||
                                        selectedStatus == null ||
                                        selectedRoleId == null) {
                                      return;
                                    }
                                    print(selectedRoleId);
                                    print(selectedStatus);
                                    await usersProvider.putUpdateUser(
                                        name,
                                        lastName,
                                        selectedStatus!,
                                        email,
                                        selectedRoleId!,
                                        user.id);
                                    NotificationsService.showSnackBar(
                                        'Usuario Actualizado');
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
                }
              },
              icon: const Icon(Icons.edit_outlined)),
          IconButton(
              onPressed: () {
                final dialog = AlertDialog(
                  title: const Text('Eliminar usuario'),
                  content:
                      Text('¿Desea eliminar al usuario ${user.firstName}?'),
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
                          await usersProvider.deleteUser(user.id);
                          NotificationsService.showSnackBar(
                              'Usuario eliminado');
                          Navigator.of(context).pop();
                        },
                        child: const Text('Eliminar')),
                  ],
                );
                showDialog(context: context, builder: (_) => dialog);
              },
              icon: const Icon(Icons.delete_outlined)),
        ],
      ))
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => users.length;

  @override
  int get selectedRowCount => 0;
  
}
