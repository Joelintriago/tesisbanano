import 'package:admin_dashboard/models/costos.dart';
import 'package:admin_dashboard/models/inventario.dart';
import 'package:admin_dashboard/models/parametrizacion.dart';
import 'package:admin_dashboard/models/permisos.dart';
import 'package:admin_dashboard/models/rentabilidad.dart';
import 'package:admin_dashboard/models/tipoReporte.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:admin_dashboard/models/usuario.dart';
import 'package:admin_dashboard/models/roles.dart';
import 'package:admin_dashboard/models/rolesPermisos.dart';

//import 'package:admin_dashboard/services/notification_service.dart';
import 'package:admin_dashboard/services/local_storage.dart';

class UsersProvider extends ChangeNotifier {
  List<Usuario> users = [];
  List<Roles> roles = [];
  List<RolesPermisos> rolesPermisos = [];
  List<Permisos> permisos = [];
  List<Permisos> permisosRol = [];
  List<Parametrizacion> parametrizacion = [];
  Usuario? usuario;
  Rol? rol;

  int rolPermiso = 0;
  bool isLoading = true;
  bool ascending = true;
  int? sortColumnIndex;

  UsersProvider() {
    getPaginatedUsers();
  }

  //Obtener los usuarios
  getPaginatedUsers() async {
    users.clear();
    const url = 'http://localhost:4000/v1/users';
    final token = LocalStorage.prefs.getString('token') ??
        ''; // Replace with your saved token

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = json.decode(responseBody);
      if (parsedResponse.containsKey('data')) {
        final List<dynamic> data = parsedResponse['data'];

        final List<Usuario> usuarios =
            data.map((item) => Usuario.fromMap(item)).toList();

        // Utiliza la lista de usuarios según tus necesidades
        usuarios.forEach((usuario) {
          users.add(usuario);
          print('Nombre: ${usuario.firstName}');
          print('Correo: ${usuario.email}');
          print('---');
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }

  //Ordenar lista

  void sort<T>(Comparable<T> Function(Usuario user) getField) {
    users.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);

      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    ascending = !ascending;

    notifyListeners();
  }

  //Obtener roles
  getRoles() async {
    roles.clear();
    const url = 'http://localhost:4000/v1/roles';
    final token = LocalStorage.prefs.getString('token') ??
        ''; // Replace with your saved token

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = json.decode(responseBody);

      if (parsedResponse.containsKey('data')) {
        final List<dynamic> data = parsedResponse['data'];
        final List<Roles> roles =
            data.map((item) => Roles.fromMap(item)).toList();
        // Utiliza la lista de usuarios según tus necesidades
        roles.forEach((rol) {
          this.roles.add(rol);
          print('Nombre: ${rol.id}');
          print('Rol nombre: ${rol.roleName}');
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }

  //Actualizar usuario
  Future<void> putUpdateUser(
    String firstName,
    String lastName,
    String state,
    String email,
    int rol,
    int idUser,
  ) async {
    final url = 'http://localhost:4000/v1/users/$idUser';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'state': state,
      'roles': [
        rol,
      ],
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode(data);

    final response =
        await http.put(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
    }

    getPaginatedUsers();
    isLoading = false;
    notifyListeners();
  }

  Future<void> postCreateUser(
    String firstName,
    String lastName,
    String state,
    String email,
    String password,
    int rol,
  ) async {
    final url = 'http://localhost:4000/v1/users';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'state': state,
      'email': email,
      'password': password,
      'roles': [
        rol,
      ],
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode(data);

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
    }

    getPaginatedUsers();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteUser(
    int idUser,
  ) async {
    final url = 'http://localhost:4000/v1/users/$idUser';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
    }

    getPaginatedUsers();
    isLoading = false;
    notifyListeners();
  }

  /*<---------------------------------------------PERMISOS---------------------------------------> */

  getPermisos() async {
    permisos.clear();
    final url = 'http://localhost:4000/v1/permissions';
    final token = LocalStorage.prefs.getString('token') ??
        ''; // Replace with your saved token

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = json.decode(responseBody);
      if (parsedResponse.containsKey('data')) {
        final List<dynamic> data = parsedResponse['data'];

        final List<Permisos> permisos =
            data.map((item) => Permisos.fromMap(item)).toList();

        // Utiliza la lista de usuarios según tus necesidades
        permisos.forEach((permiso) {
          this.permisos.add(permiso);
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }

  getPermisosRol(int id) async {
    permisosRol.clear();
    this.rolPermiso = id;

    final url = 'http://localhost:4000/v1/roles/$id/permissions';
    final token = LocalStorage.prefs.getString('token') ??
        ''; // Replace with your saved token

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = json.decode(responseBody);
      if (parsedResponse.containsKey('data')) {
        final List<dynamic> data = parsedResponse['data']['permissions'];

        final List<Permisos> permisos =
            data.map((item) => Permisos.fromMap(item)).toList();

        // Utiliza la lista de usuarios según tus necesidades
        permisos.forEach((permiso) {
          this.permisosRol.add(permiso);
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> putUpdatePermisos(
    List<Permisos> permisos,
    bool aggOrDelete,
    int id,
  ) async {
    if (rolPermiso == 0) return;
    final url = 'http://localhost:4000/v1/roles/$rolPermiso';
    final token = LocalStorage.prefs.getString('token') ?? '';
    List<int> permisosR = [];
    if (aggOrDelete == true) {
      permisos.forEach((element) {
        if (id == element.id) {
        } else {
          permisosR.add(element.id);
        }
        print('Lista permisos antes $permisosR y rol: $rolPermiso');
      });
    } else {
      permisosR.add(id);
      permisos.forEach((element) {
        permisosR.add(element.id);
      });
    }

    final data = {
      'permissions': permisosR,
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode(data);

    final response =
        await http.put(Uri.parse(url), headers: headers, body: body);
    print("aqui respuesta" + response.body);

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
    }

    isLoading = false;

    getPermisosRol(rolPermiso);
    notifyListeners();
  }

  getRolesPermisos() async {
    const url = 'http://localhost:4000/v1/roles/findR';
    final token = LocalStorage.prefs.getString('token') ??
        ''; // Replace with your saved token

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = json.decode(responseBody);

      if (parsedResponse.containsKey('data')) {
        final List<dynamic> data = parsedResponse['data'];
        final List<RolesPermisos> roles =
            data.map((item) => RolesPermisos.fromMap(item)).toList();
        // Utiliza la lista de usuarios según tus necesidades
        roles.forEach((rol) {
          this.rolesPermisos.add(rol);
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }

  //-------------------------------------------Parametrizacion----------------------------------------//

  Future<void> deleteParametrizacion(
    int id,
  ) async {
    final url = 'http://localhost:4000/v1/planning-sowing/$id';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
    }

    getSiembra();
    isLoading = false;
    notifyListeners();
  }

  getSiembra() async {
    parametrizacion.clear();
    final url = 'http://localhost:4000/v1/planning-sowing';
    final token = LocalStorage.prefs.getString('token') ??
        ''; // Replace with your saved token

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = json.decode(responseBody);
      if (parsedResponse.containsKey('data')) {
        final List<dynamic> data = parsedResponse['data'];

        final List<Parametrizacion> parametrizaciones =
            data.map((item) => Parametrizacion.fromMap(item)).toList();

        // Utiliza la lista de usuarios según tus necesidades
        parametrizaciones.forEach((parametrizacion) {
          this.parametrizacion.add(parametrizacion);
          print('Nombre: ${parametrizacion.id}');
          print('Correo: ${parametrizacion.climaticCondition}');
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> putUpdateParametrizacion(
    String climaticCondition,
    String nameSeed,
    String bananaVariety,
    double fertilizerQuantity,
    double pesticideQuantity,
    String fechaFumigacion,
    String riego,
    String fechainicio,
    String fechafin,
    int selectedSowing,
    double peso,
    int numerB,
    int rechazadosB,
    int numLote,
    int id,
  ) async {
    final url = 'http://localhost:4000/v1/planning-sowing/$id';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final data = {
      "climaticCondition": climaticCondition,
      "seedName": nameSeed,
      "bananaVariety": bananaVariety,
      "fertilizerQuantityKG": fertilizerQuantity,
      "pesticideQuantityKG": pesticideQuantity,
      "fumigationDate": fechaFumigacion,
      "irrigation": riego,
      "sowingDate": fechainicio,
      "sowingDateEnd": fechafin,
      "estimatedSowingTime": selectedSowing,
      "rejectedBunches": rechazadosB,
      "numberOfBunches": numerB,
      "averageBunchWeight": peso,
      "batchNumber": numLote
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode(data);

    final response =
        await http.put(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
    }

    getSiembra();
    isLoading = false;
    notifyListeners();
  }

  Future<void> postCreateParametrizacion(
    String climaticCondition,
    String nameSeed,
    String bananaVariety,
    double fertilizerQuantity,
    double pesticideQuantity,
    String fechaFumigacion,
    String riego,
    String fechainicio,
    String fechafin,
    int selectedSowing,
    double peso,
    int numerB,
    int rechazadosB,
    int numLote,
  ) async {
    final url = 'http://localhost:4000/v1/planning-sowing';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final data = {
      "climaticCondition": climaticCondition,
      "seedName": nameSeed,
      "bananaVariety": bananaVariety,
      "fertilizerQuantityKG": fertilizerQuantity,
      "pesticideQuantityKG": pesticideQuantity,
      "fumigationDate": fechaFumigacion,
      "irrigation": riego,
      "sowingDate": fechainicio,
      "sowingDateEnd": fechafin,
      "estimatedSowingTime": selectedSowing,
      "rejectedBunches": rechazadosB,
      "numberOfBunches": numerB,
      "averageBunchWeight": peso,
      "batchNumber": numLote
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode(data);

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);
    print(response);

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
    }

    getSiembra();
    isLoading = false;
    notifyListeners();
  }
}
