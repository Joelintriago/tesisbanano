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
        NotificationsService.showSnackbarError('Email no válidos');
      }
    } catch (e) {
      print('error en: $e');
      NotificationsService.showSnackbarError(
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
        NotificationsService.showSnackbarError(
            'No se pudo cambiar la contraseña');
      }
    } catch (e) {
      print('error en: $e');
      NotificationsService.showSnackbarError(
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
}
