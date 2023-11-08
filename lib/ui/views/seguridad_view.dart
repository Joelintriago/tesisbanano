import 'package:admin_dashboard/models/rolesPermisos.dart';
import 'package:flutter/material.dart';

import 'package:admin_dashboard/datatables/users_datasource.dart';
import 'package:admin_dashboard/datatables/permisso_datasource.dart';

import 'package:admin_dashboard/models/roles.dart';

import 'package:admin_dashboard/providers/users_provider.dart';

import 'package:admin_dashboard/services/notification_service.dart';

import 'package:admin_dashboard/ui/buttons/custom_icon_button.dart';

import 'package:provider/provider.dart';
//import 'package:email_validator/email_validator.dart';

class UsersView extends StatefulWidget {
  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  int c = 0;
  bool per = false;
  @override
  @override
  void didChangeDependencies() {
    if (c == 0) {
      super.didChangeDependencies();
      Provider.of<UsersProvider>(context).getRolesPermisos();
      Provider.of<UsersProvider>(context).getPermisos();

      c++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: true);
    final usersDataSource = UsersDataSource(usersProvider.users, context);

    final rolesP = usersProvider.rolesPermisos;
    final permisosRol = usersProvider.permisosRol;
    final permisos = usersProvider.permisos;
    final permisosDataSource =
        PermisosDataSource(permisos, this.context, permisosRol, false);
    bool _showPassword = false;

    int? selectedRoleId;
   

    return DefaultTabController(
      length: 2, // Número de pestañas (Usuarios y Permisos)
      child: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white, // Fondo blanco
                  child: const Center(
                    child: Text('Usuarios', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  color: Colors.white, // Fondo blanco
                  child: const Center(
                    child: Text('Permisos', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Contenido de la pestaña "Usuarios"
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: const Color.fromARGB(183, 198, 199, 157)
                          .withOpacity(0.9),
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        physics: const ClampingScrollPhysics(),
                        children: [
                          PaginatedDataTable(
                            sortAscending: usersProvider.ascending,
                            sortColumnIndex: usersProvider.sortColumnIndex,
                            columns: [
                              const DataColumn(label: Text('Id')),
                              DataColumn(
                                label: const Text('Nombre'),
                                onSort: (ColIndex, _) {
                                  usersProvider.sortColumnIndex = ColIndex;
                                  usersProvider
                                      .sort<String>((user) => user.email);
                                },
                              ),
                              const DataColumn(label: Text('Apellido')),
                              DataColumn(
                                label: const Text('Email'),
                                onSort: (colIndex, _) {
                                  usersProvider.sortColumnIndex = colIndex;
                                  usersProvider
                                      .sort<String>((user) => user.email);
                                },
                              ),
                              const DataColumn(label: Text('Rol')),
                              const DataColumn(label: Text('Estado')),
                              const DataColumn(label: Text('Acciones')),
                            ],
                            source: usersDataSource,
                            onPageChanged: (page) {
                              print('page: $page');
                            },
                            header: const Center(child: Text('Usuarios')),
                            actions: [
                              CustomIconButton(
                                text: 'Crear',
                                icon: Icons.add_outlined,
                                onPressed: () async {
                                  await usersProvider.getRoles();
                                  final TextEditingController nameController =
                                      TextEditingController();
                                  final TextEditingController emailController =
                                      TextEditingController();
                                  final TextEditingController
                                      lastNameController =
                                      TextEditingController();
                                  final TextEditingController
                                      passwordController =
                                      TextEditingController();
                                  String? selectedStatus;
                                  int? selectedRoleId;
                                  if (context.mounted) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter setState) {
                                            return SingleChildScrollView(
                                              child: AlertDialog(
                                                title:
                                                    const Text('Crear usuario'),
                                                content: Column(
                                                  children: [
                                                    TextField(
                                                      controller:
                                                          emailController,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Email'),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          nameController,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Nombre'),
                                                    ),
                                                    TextField(
                                                      controller:
                                                          lastNameController,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Apellido'),
                                                    ),
                                                    DropdownButtonFormField<
                                                        String>(
                                                      value: selectedStatus,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText:
                                                                  'Estado'),
                                                      items: [
                                                        'activo',
                                                        'inactivo'
                                                      ]
                                                          .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                            (String value) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                              value: value,
                                                              child:
                                                                  Text(value),
                                                            ),
                                                          )
                                                          .toList(),
                                                      onChanged:
                                                          (String? value) {
                                                        selectedStatus = value;
                                                      },
                                                    ),
                                                    DropdownButtonFormField<
                                                        Roles>(
                                                      value: null,
                                                      decoration:
                                                          const InputDecoration(
                                                              labelText: 'Rol'),
                                                      items: usersProvider.roles
                                                          .map<
                                                              DropdownMenuItem<
                                                                  Roles>>(
                                                            (Roles rol) =>
                                                                DropdownMenuItem<
                                                                    Roles>(
                                                              value: rol,
                                                              child: Text(
                                                                  rol.roleName),
                                                            ),
                                                          )
                                                          .toList(),
                                                      onChanged:
                                                          (Roles? value) {
                                                        selectedRoleId =
                                                            value?.id;
                                                      },
                                                    ),
                                                    TextField(
                                                      controller:
                                                          passwordController,
                                                      obscureText:
                                                          !_showPassword, // Oculta la contraseña si _showPassword es false
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Contraseña',
                                                        suffixIcon: IconButton(
                                                          icon: Icon(_showPassword
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off),
                                                          onPressed: () {
                                                            setState(() {
                                                              _showPassword =
                                                                  !_showPassword; // Cambia el estado de visibilidad de la contraseña
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text('Cancelar'),
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        final String name =
                                                            nameController.text;
                                                        final String lastName =
                                                            lastNameController
                                                                .text;
                                                        final String password =
                                                            passwordController
                                                                .text;
                                                        final String email =
                                                            emailController
                                                                .text;
                                                        if (email.isEmpty ||
                                                            name.isEmpty ||
                                                            lastName.isEmpty ||
                                                            selectedStatus ==
                                                                null) {
                                                          NotificationsService
                                                              .showSnackBarError(
                                                                  'Faltan campos');
                                                          return;
                                                        }
                                                        await usersProvider
                                                            .postCreateUser(
                                                                name,
                                                                lastName,
                                                                selectedStatus!,
                                                                email,
                                                                password,
                                                                selectedRoleId!);
                                                        NotificationsService
                                                            .showSnackBar(
                                                                'Usuario creado');
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child:
                                                          const Text('Guardar'))
                                                ],
                                              ),
                                            );
                                          });
                                        });
                                  }
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Contenido de la pestaña "Permisos"
                Card(
                  elevation: 10,
                  child: ListView(
                    physics: const ClampingScrollPhysics(),
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Container(
                            width: 200,
                            child: DropdownButtonFormField<RolesPermisos>(
                              value: null,
                              decoration:
                                  InputDecoration(labelText: 'Escoja un rol'),
                              items: rolesP
                                  .map<DropdownMenuItem<RolesPermisos>>(
                                    (RolesPermisos rol) => DropdownMenuItem<RolesPermisos>(
                                      value: rol,
                                      child: Text(rol.roleName),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (RolesPermisos? value) async {
                                
                                selectedRoleId = value?.id;
                                await Provider.of<UsersProvider>(context,
                                        listen: false)
                                    .getPermisosRol(selectedRoleId!);
                                per = true;
                                setState(() {
                                   
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      if (per == true)
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: PaginatedDataTable(
                              sortAscending: usersProvider.ascending,
                              sortColumnIndex: usersProvider.sortColumnIndex,
                              header: const Center(
                                  child: Text(
                                "Permisos",
                                style: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                              )),
                              headingRowHeight: 100,
                              columns: const[
                                DataColumn(label: Text('Id')),
                                DataColumn(label: Text('Descripción')),
                                DataColumn(label: Text('Permiso')),
                                DataColumn(label: Text('Dar/Quitar')),
                              ],
                              source: permisosDataSource,
                              onPageChanged: (page) {},
                            ),
                          )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}