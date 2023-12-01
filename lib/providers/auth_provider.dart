import 'dart:convert';
import 'package:admin_dashboard/api/CafeApi.dart';
import 'package:admin_dashboard/models/htpp/auth_response.dart';
import 'package:admin_dashboard/services/notification_service.dart';
import 'package:http/http.dart' as http;
import 'package:admin_dashboard/router/router.dart';
import 'package:admin_dashboard/services/local_storage.dart';
import 'package:admin_dashboard/services/navigation_service.dart';

import 'package:flutter/material.dart';

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  GlobalKey<FormState> formKey2 = new GlobalKey<FormState>();
  String? _token;
  AuthStatus authStatus = AuthStatus.checking;
  User? user;
  List<Role> role = [];

  AuthProvider() {
    this.isAuthenticated();
  }

  login(String email, String password) async {
    final url = Uri.parse('http://localhost:4000/v1/auth/signin');
    final data = {
      'email': email,
      'password': password,
    };

    try {
      final response = await http.post(url, body: data);
      final jsonResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromMap(jsonResponse);
        final userRoles = authResponse.data.user.roles;

        /*final Map<String, dynamic> userData = data['user'];
          final List<dynamic> rolesList = userData['roles'];
          final List<Role> roles =
              rolesList.map((role) => Role.fromMap(role)).toList();*/

        final List<Role> rolesList = userRoles!;
        this.role = rolesList;
        /*final roles = userRoles?.map((role) {
          this.role = Role(
            id: role.id,
            roleName: role.roleName,
            roleCode: role.roleCode,
          );
        }).toList();*/

        this.user = User(
          id: authResponse.data.user.id,
          email: authResponse.data.user.email,
          firstName: authResponse.data.user.firstName,
          lastName: authResponse.data.user.lastName,
          roles: role,
        );

        _token = authResponse.data.token;
        authStatus = AuthStatus.authenticated;
        // Guardar el token en el almacenamiento local
        LocalStorage.prefs.setString('token', _token!);

        // Configurar la instancia Dio con el token
        CafeApi.configureDio();

        // Notificar a los oyentes que el estado de autenticación ha cambiado
        notifyListeners();

        // Navegar a la página de inicio o al dashboard después de iniciar sesión
        NavigationService.replaceTo(Flurorouter.dashboardRoute);
      } else {
        NotificationsService.showSnackBarError(
            'Usuario / Password incorrectos');
      }
    } catch (e) {
      print('error en: $e');
      NotificationsService.showSnackBarError(
          'Ha ocurrido un error en el servidor');
    }
  }

  ressetPassword(String email) async {
    final url = Uri.parse('http://localhost:4000/v1/auth/reset-password');
    final data = {
      'email': email,
    };

    try {
      final response = await http.post(url, body: data);

      if (response.statusCode == 200) {
        NavigationService.replaceTo(Flurorouter.loginRoute);
        NotificationsService.showSnackBar('Correo enviado');
      } else {
        NotificationsService.showSnackBarError('Email no válidos');
      }
    } catch (e) {
      print('error en: $e');
      NotificationsService.showSnackBarError(
          'Ha ocurrido un error en el servidor');
    }
  }

  changedPassword(String password, String token) async {
    final url =
        Uri.parse('http://localhost:4000/v1/auth/reset-password/$token');
    final data = {
      'password': password,
    };

    try {
      final response = await http.put(url, body: data);

      if (response.statusCode == 200) {
        NavigationService.replaceTo(Flurorouter.loginRoute);
        NotificationsService.showSnackBar('Contraseña cambiada con éxito');
      } else {
        NotificationsService.showSnackBarError(
            'No se pudo cambiar la contraseña');
      }
    } catch (e) {
      print('error en: $e');
      NotificationsService.showSnackBarError(
          'Ha ocurrido un error en el servidor');
    }
  }

  Future<bool> isAuthenticated() async {
    final token = LocalStorage.prefs.getString('token');

    if (token == null) {
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }

    try {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http
          .get(Uri.parse('http://localhost:4000/v1/auth'), headers: headers);

      final responseBody = response.body;
      final parsedResponse = json.decode(responseBody);

      if (parsedResponse.containsKey('data')) {
        final Map<String, dynamic> data = parsedResponse['data'];

        if (data.containsKey('tokenFinal')) {
          final String tokenFinal = data['tokenFinal'];
          // Guarda el token en el LocalStorage
          LocalStorage.prefs.setString('token', tokenFinal);
          authStatus = AuthStatus.authenticated;
        }
        if (data.containsKey('user')) {
          final Map<String, dynamic> userData = data['user'];
          final List<dynamic> rolesList = userData['roles'];
          final List<Role> roles =
              rolesList.map((role) => Role.fromMap(role)).toList();

          this.user = User(
              id: userData['id'],
              email: userData['email'],
              firstName: userData['firstName'],
              lastName: userData['lastName'],
              roles: roles);
        }
      }

      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      authStatus = AuthStatus.notAuthenticated;
      notifyListeners();
      return false;
    }
  }

  logout() {
    LocalStorage.prefs.remove('token');
    authStatus = AuthStatus.notAuthenticated;
    notifyListeners();
  }

  bool _validForm() {
    return formKey.currentState!.validate();
  }

  bool _validForm2() {
    return formKey2.currentState!.validate();
  }

  Future putUpdateProfileUser(
    String firstName,
    String lastName,
    String email,
  ) async {
    final url = 'http://localhost:4000/v1/auth/info';
    final token = LocalStorage.prefs.getString('token') ?? '';

    if (!this._validForm()) {
      NotificationsService.showSnackBarError('Formulario incorrecto');
      return false;
    }

    final data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final body = json.encode(data);
      print(body);
      await http.put(Uri.parse(url), headers: headers, body: body);
      NotificationsService.showSnackBar('Información actualizada');
      notifyListeners();
      this.isAuthenticated();
      return true;
    } catch (e) {
      print('error en updateUser: $e');
      NotificationsService.showSnackBarError('No se pudo actualizar');
      return false;
    }
  }

  Future putUpdatePaswword(
    String password,
    String newPassword,
  ) async {
    final url = 'http://localhost:4000/v1/auth/update-password';
    final token = LocalStorage.prefs.getString('token') ?? '';

    if (!this._validForm2()) {
      NotificationsService.showSnackBarError('Formulario incorrecto');
      return false;
    }

    final data = {'password': password, 'newPassword': newPassword};

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final body = json.encode(data);
      print(body);
      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Contraseña actualizada');
        NotificationsService.showSnackBar('Contraseña actualizada');
      } else {
        print(
            'El servidor devolvió un estado diferente de 200: ${response.statusCode}');
        NotificationsService.showSnackBarError('No se pudo actualizar');
      }
    } catch (e) {
      print('error en updateUser: $e');
      NotificationsService.showSnackBarError('No se pudo actualizar');
      return false;
    }
  }
}
