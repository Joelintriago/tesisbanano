import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'package:admin_dashboard/datatables/users_datasource.dart';
import 'package:admin_dashboard/datatables/permisso_datasource.dart';

import 'package:admin_dashboard/models/roles.dart';
import 'package:admin_dashboard/models/rolesPermisos.dart';
import 'package:admin_dashboard/models/usuario.dart';

import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:admin_dashboard/providers/init_provider.dart';

import 'package:admin_dashboard/services/notification_service.dart';

import 'package:admin_dashboard/ui/buttons/custom_icon_button.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';

//import 'package:email_validator/email_validator.dart';

class UsersView extends StatefulWidget {
  @override
  State<UsersView> createState() => _UsersViewState();
}

class _UsersViewState extends State<UsersView> {
  final TextEditingController _filterController = TextEditingController();
  List<Usuario> filterData = [];

  int c = 0;
  bool per = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final miVariable = Provider.of<MiInicializador>(context);
    // Realizar las operaciones dependientes de InheritedWidget
    if (miVariable.c == 0) {
      Provider.of<UsersProvider>(context).getRolesPermisos();
      print('imprimiendo $miVariable.c');
      miVariable.incrementC();
      print('imprimiendo $miVariable.c');
    }
    if (c == 0) {
      Provider.of<UsersProvider>(context).getPermisos();
      c++;
    }
  }

  @override
  Widget build(BuildContext context) {
    final usersProvider = Provider.of<UsersProvider>(context, listen: true);
    final usersDataSource =
        UsersDataSource(usersProvider.users, context, false);

    final rolesP = usersProvider.rolesPermisos;
    final permisosRol = usersProvider.permisosRol;
    final permisos = usersProvider.permisos;
    final permisosDataSource =
        PermisosDataSource(permisos, this.context, permisosRol, false);
    bool _showPassword = false;
    filterData = usersDataSource.users;

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
                            header: Row(
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Container(
                                    width: 200,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: TextField(
                                        decoration: const InputDecoration(
                                          hintText: 'Filtrar por nombre...',
                                        ),
                                        controller: _filterController,
                                        onChanged: (value) async {
                                          setState(() {
                                            if (value.isNotEmpty) {
                                              print('Texto ingresado: $value');
                                              usersProvider.users = filterData
                                                  .where((element) => element
                                                      .firstName
                                                      .toLowerCase()
                                                      .contains(
                                                          value.toLowerCase()))
                                                  .toList();

                                              print(
                                                  'Data filtrada ${usersProvider.users}');
                                            } else {
                                              usersProvider.getPaginatedUsers();
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                    flex: 1,
                                    child: Container(
                                        margin: EdgeInsets.only(left: 30),
                                        child: Center(
                                          child: Text('Usuarios'),
                                        )))
                              ],
                            ),
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
                                                content: Form(
                                                  autovalidateMode:
                                                      AutovalidateMode.always,
                                                  key: usersProvider
                                                      .formKeyCreate,
                                                  child: Column(
                                                    children: [
                                                      TextFormField(
                                                        controller:
                                                            emailController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Email'),
                                                        validator: (value) {
                                                          if (!EmailValidator
                                                              .validate(
                                                                  value ?? ''))
                                                            return 'Email no válido';
                                                          return null;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value!.length <
                                                              3) {
                                                            return ('Escriba 3 o más caracteres');
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            nameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Nombre'),
                                                        inputFormatters: <TextInputFormatter>[
                                                          // for below version 2 use this
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                 r'^[a-zA-Z\s]+$')),
                                                        ],
                                                      ),
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value!.length <
                                                              3) {
                                                            return ('Escriba 3 o más caracteres');
                                                          }
                                                          return null;
                                                        },
                                                        controller:
                                                            lastNameController,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Apellido'),
                                                        inputFormatters: <TextInputFormatter>[
                                                          // for below version 2 use this
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  r'^[a-zA-Z\s]+$')),
                                                        ],
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
                                                          selectedStatus =
                                                              value;
                                                        },
                                                      ),
                                                      DropdownButtonFormField<
                                                          Roles>(
                                                        value: null,
                                                        decoration:
                                                            const InputDecoration(
                                                                labelText:
                                                                    'Rol'),
                                                        items: usersProvider
                                                            .roles
                                                            .map<
                                                                DropdownMenuItem<
                                                                    Roles>>(
                                                              (Roles rol) =>
                                                                  DropdownMenuItem<
                                                                      Roles>(
                                                                value: rol,
                                                                child: Text(rol
                                                                    .roleName),
                                                              ),
                                                            )
                                                            .toList(),
                                                        onChanged:
                                                            (Roles? value) {
                                                          selectedRoleId =
                                                              value?.id;
                                                        },
                                                      ),
                                                      TextFormField(
                                                        validator: (value) {
                                                          if (value!.length <
                                                              3) {
                                                            return 'La contraseña debe ser de 3 caracteres';
                                                          }
                                                        },
                                                        controller:
                                                            passwordController,
                                                        obscureText:
                                                            !_showPassword, // Oculta la contraseña si _showPassword es false
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              'Contraseña',
                                                          suffixIcon:
                                                              IconButton(
                                                            icon: Icon(_showPassword
                                                                ? Icons
                                                                    .visibility
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
                                                        if (usersProvider
                                                                .validFormCreate() ==
                                                            true) {
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
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
                                    (RolesPermisos rol) =>
                                        DropdownMenuItem<RolesPermisos>(
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
                                setState(() {});
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
                            columns: const [
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
