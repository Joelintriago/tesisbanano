import 'package:flutter/material.dart';

import 'package:admin_dashboard/models/permisos.dart';

import 'package:admin_dashboard/services/notification_service.dart';

import 'package:admin_dashboard/providers/users_provider.dart';
import 'package:provider/provider.dart';

class PermisosDataSource extends DataTableSource {
  final List<Permisos> permisos;
  final List<Permisos> permisosRol;
  final BuildContext context;
  final bool report;
  PermisosDataSource(
      this.permisos, this.context, this.permisosRol, this.report);

  @override
  DataRow getRow(int index) {
    final Permisos permiso = permisos[index];
    bool hasPermisoRol =
        permisosRol.any((permisoRol) => permisoRol.id == permiso.id);
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text(permiso.id.toString())),
      DataCell(Text(permiso.description)),
      DataCell(
        hasPermisoRol
            ? const Icon(Icons.check,
                color: Colors.green) // Ícono de visto verde
            : const Icon(Icons.close, color: Colors.red), // X roja
      ),
      if (report != true)
        DataCell(
          Row(
            children: [
              IconButton(
                  icon: const Icon(
                    Icons.edit_attributes,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    final usersProvider =
                        Provider.of<UsersProvider>(context, listen: false);

                    await usersProvider.putUpdatePermisos(
                        permisosRol, hasPermisoRol, permiso.id);
                    NotificationsService.showSnackBar('Permiso Actualizado');
                  })
            ],
          ),
        ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => this.permisos.length;

  @override
  int get selectedRowCount => 0;
}
