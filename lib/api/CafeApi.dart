import 'package:admin_dashboard/services/local_storage.dart';
import 'package:dio/dio.dart';

class CafeApi {
  static Dio _dio = new Dio();

static void configureDio() async {
  // Base del URL
  _dio.options.baseUrl = 'http://localhost:4000/v1';

  // Obtener el token desde el LocalStorage
  String? token = LocalStorage.prefs.getString('token');

  // Verificar si se encontró un token
  if (token != null) {
    // Configurar los headers con el token
    _dio.options.headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
}


  static Future httpGet(String path) async {
    try {
      final resp = await _dio.get(path);
      return resp.data;
    } catch (e) {
      print(e);
      throw ('Error en el GET');
    }
  }

  static Future post(String path, Map<String, dynamic> data) async {
    final formData = FormData.fromMap(data);

    try {
      final resp = await _dio.post(path, data: formData);

      return resp.data;
    } catch (e) {
      print(e);
      throw ('Error en el POST');
    }
  }
}
