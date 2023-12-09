import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:admin_dashboard/models/usuario.dart';
import 'package:admin_dashboard/models/roles.dart';
import 'package:admin_dashboard/models/rolesPermisos.dart';
import 'package:admin_dashboard/models/costos.dart';
import 'package:admin_dashboard/models/inventario.dart';
import 'package:admin_dashboard/models/parametrizacion.dart';
import 'package:admin_dashboard/models/permisos.dart';
import 'package:admin_dashboard/models/rentabilidad.dart';
import 'package:admin_dashboard/models/tipoReporte.dart';

//import 'package:admin_dashboard/services/notification_service.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/notification_service.dart';

class UsersProvider extends ChangeNotifier {
  List<Usuario> users = [];
  List<Roles> roles = [];
  List<RolesPermisos> rolesPermisos = [];
  List<Permisos> permisos = [];
  List<Permisos> permisosRol = [];
  List<ReporteTipo> reporteTipos = [];
  List<Parametrizacion> parametrizacion = [];
  List<Inventario> inventario = [];
  List<Costos> costos = [];
  List<Rentabilidad> rentabilidad = [];
  Usuario? usuario;
  Rol? rol;

  int rolPermiso = 0;
  bool isLoading = true;
  bool ascending = true;
  int? sortColumnIndex;

  GlobalKey<FormState> formKeyCreate = new GlobalKey<FormState>();
  GlobalKey<FormState> formKeyUpdate = new GlobalKey<FormState>();

  UsersProvider() {
    getPaginatedUsers();
  }

  //Validar formularios
  bool validFormCreate() {
    return formKeyCreate.currentState!.validate();
  }

  bool validFormUpdate() {
    return formKeyUpdate.currentState!.validate();
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

    if (validFormUpdate() == true) {
      final body = json.encode(data);

      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        NotificationsService.showSnackBar('Usuario actualizado');
      }else{
        NotificationsService.showSnackBarError('Error al actualizar');
      }

      getPaginatedUsers();
      isLoading = false;
      notifyListeners();
    }else{
      NotificationsService.showSnackBarError('Campos incorrectos');
    }
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

    if (validFormCreate() == true) {
      final body = json.encode(data);

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        // La solicitud fue exitosa
        NotificationsService.showSnackBar('Usuario creado');
      } else {
        NotificationsService.showSnackBarError('Error al crear usuario');
      }

      getPaginatedUsers();
      isLoading = false;
      notifyListeners();
    } else {
      NotificationsService.showSnackBarError('Campos incorrectos');
    }
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
      NotificationsService.showSnackBar('Parametrización eliminada');
    } else {
      NotificationsService.showSnackBarError(
          'Existen rentabilidades calculadas con este registro');
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

  //------------------------------- Costos------------------------------------//

  getCostos() async {
    costos.clear();
    final url = 'http://localhost:4000/v1/cost-records';
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

        final List<Costos> costos =
            data.map((item) => Costos.fromMap(item)).toList();

        // Utiliza la lista de usuarios según tus necesidades
        costos.forEach((costo) {
          this.costos.add(costo);
          print('Nombre: ${costo.id}');
          print('Correo: ${costo.description}');
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> putUpdateCostos(
    String descripcion,
    double manoO,
    double combustible,
    int inventario,
    double total,
    int id,
  ) async {
    final url = 'http://localhost:4000/v1/cost-records/$id';
    final token = LocalStorage.prefs.getString('token') ?? '';
    final double? insumo = await this.getInventarioXid(inventario);
    double tInsumo = insumo! + total;
    final data = {
      "description": descripcion,
      "input": insumo,
      "labor": manoO,
      "fuel": combustible,
      "totalCosts": tInsumo,
      "inventoryId": inventario,
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

    getCostos();
    isLoading = false;
    notifyListeners();
  }

  Future<double> getInventarioXid(int id) async {
    final url = 'http://localhost:4000/v1/inventory/$id';
    final token = LocalStorage.prefs.getString('token') ??
        ''; // Replace with your saved token

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(Uri.parse(url), headers: headers);
    print(response.body);

    if (response.statusCode == 200) {
      final responseBody = response.body;
      final parsedResponse = json.decode(responseBody);
      if (parsedResponse.containsKey('data')) {
        final dynamic data = parsedResponse['data'];
        final Inventario inventario = Inventario.fromMap(data);

        // Realiza los cálculos necesarios para obtener el valor total
        double x = inventario.quantity * inventario.unitPrice;
        //double totalQuantity = total + x;

        // Retorna el valor total calculado
        return x;
        // Calculate and return the sum of all quantities
      }
    }

    isLoading = false;
    notifyListeners();

    // Return a default value or an appropriate value indicating an error
    return 0;
  }

  Future<void> deleteCostos(
    int id,
  ) async {
    final url = 'http://localhost:4000/v1/cost-records/$id';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      NotificationsService.showSnackBar('Costo Eliminado');
    } else {
      NotificationsService.showSnackBarError(
          'Existen registros de rentabilidad con el costo');
    }

    getInventario();
    getCostos();
    isLoading = false;
    notifyListeners();
  }

  Future<void> postCreateCosto(
    String descripcion,
    double manoO,
    double combustible,
    int inventario,
    double total,
  ) async {
    final url = 'http://localhost:4000/v1/cost-records';
    final token = LocalStorage.prefs.getString('token') ?? '';
    final double? insumo = await this.getInventarioXid(inventario);
    double tInsumo = insumo! + total;
    final data = {
      "description": descripcion,
      "input": insumo,
      "labor": manoO,
      "fuel": combustible,
      "totalCosts": tInsumo,
      "inventoryId": inventario,
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
      getCostos();
      isLoading = false;
      notifyListeners();
      NotificationsService.showSnackBar('Costo agregado');
    } else {
      NotificationsService.showSnackBarError(
          'No cuenta con los permisos necesarios.');
    }
  }

  //--------------------------------Inventario----------------------------------------

  getInventario() async {
    inventario.clear();
    final url = 'http://localhost:4000/v1/inventory';
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

        final List<Inventario> inventarios =
            data.map((item) => Inventario.fromMap(item)).toList();

        // Utiliza la lista de usuarios según tus necesidades
        inventarios.forEach((inventario) {
          this.inventario.add(inventario);
          print('Nombre: ${inventario.id}');
          print('Correo: ${inventario.product}');
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> putUpdateInventario(
    String producto,
    String descripcion,
    String fecha,
    double precio,
    int cantidad,
    int id,
  ) async {
    final url = 'http://localhost:4000/v1/inventory/$id';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final data = {
      'purchaseDate': fecha,
      'description': descripcion,
      'product': producto,
      'unitPrice': precio,
      'quantity': cantidad,
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode(data);

    final response =
        await http.put(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      NotificationsService.showSnackBar('Inventario Actualizado');
    } else {
      NotificationsService.showSnackBarError('No se pudo Actualizado');
    }

    getInventario();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteInventario(
    int id,
  ) async {
    final url = 'http://localhost:4000/v1/inventory/$id';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      NotificationsService.showSnackBar('Inventario Eliminado');
    } else {
      NotificationsService.showSnackBarError('No se pudo Eliminado');
    }

    getInventario();
    isLoading = false;
    notifyListeners();
  }

  Future<void> postCreateInventario(
    String producto,
    String descripcion,
    String fecha,
    double precio,
    int cantidad,
  ) async {
    final url = 'http://localhost:4000/v1/inventory';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final data = {
      'purchaseDate': fecha,
      'description': descripcion,
      'product': producto,
      'unitPrice': precio,
      'quantity': cantidad,
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
      getInventario();
      isLoading = false;
      notifyListeners();
      NotificationsService.showSnackBar('Producto agregado al inventario');
    } else {
      NotificationsService.showSnackBarError(
          'Existen registros de costos con este inventario.');
    }
  }

  //---------------------------------Rentabilidad---------------------------------

  getRentabilidad() async {
    rentabilidad.clear();
    final url = 'http://localhost:4000/v1/profitability';
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

        final List<Rentabilidad> rentab =
            data.map((item) => Rentabilidad.fromMap(item)).toList();

        // Utiliza la lista de usuarios según tus necesidades
        rentab.forEach((rent) {
          this.rentabilidad.add(rent);
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> postCreateRentabilidad(
    int costos,
    int planing,
  ) async {
    final url = 'http://localhost:4000/v1/profitability';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final data = {"costRecordId": costos, "planningSowing2Id": planing};

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = json.encode(data);

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      // La solicitud fue exitosa
      getRentabilidad();
      isLoading = false;
      notifyListeners();
      NotificationsService.showSnackBar('Rentabilidad agregada');
    } else {
      NotificationsService.showSnackBarError(
          'No cuenta con los permisos necesarios.');
    }
  }

  Future<void> deleteRentabilidad(
    int id,
  ) async {
    final url = 'http://localhost:4000/v1/profitability/$id';
    final token = LocalStorage.prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.delete(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      NotificationsService.showSnackBar('Rentabilidad eliminada');
    }

    getRentabilidad();
    isLoading = false;
    notifyListeners();
  }

  //------------------------------- Reporte ------------------------------
  getTipoReporte() async {
    reporteTipos.clear();
    final url = 'http://localhost:4000/v1/reports/types';
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

        final List<ReporteTipo> reporteTip =
            data.map((item) => ReporteTipo.fromMap(item)).toList();

        // Utiliza la lista de usuarios según tus necesidades
        reporteTip.forEach((reporteT) {
          this.reporteTipos.add(reporteT);
        });
      }
    }

    isLoading = false;
    notifyListeners();
  }
}
