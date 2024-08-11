import 'dart:convert';
import 'package:crud_interview/models/user_model.dart';
import 'package:crud_interview/utils/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crud_interview/utils/api_constants.dart';

class AuthService {
  static Future<Map<String, String>> login(String phone, String pin) async {
    final response = await http.post(
      Uri.parse('${APIConstants.authAPIUrl}/login'),
      headers: {'Accept': 'application/json'},
      body: {'phone': phone, 'password': pin},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final userData = responseData['data'];

      await SecureStorage.saveToken(token); // Simpan token

      return {
        'name': userData['name'],
        'phone': userData['phone'],
      };
    } else if (jsonDecode(response.body)['message'] != null) {
      return {
        'message': jsonDecode(response.body)['message'],
      };
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<Map<String, String>> register(
      {required String fullName,
      required String phone,
      required String pin}) async {
    final response = await http.post(
      Uri.parse('${APIConstants.authAPIUrl}/register'),
      headers: {'Accept': 'application/json'},
      body: {'name': fullName, 'phone': phone, 'password': pin},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final token = responseData['token'];
      final userData = responseData['data'];

      await SecureStorage.saveToken(token); // Simpan token

      return {
        'name': userData['name'],
        'phone': userData['phone'],
      };
    } else if (jsonDecode(response.body)['message'] != null) {
      return {
        'message': jsonDecode(response.body)['message'],
      };
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<UserModel> getUser() async {
    final token = await SecureStorage.getToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    final response = await http.get(
      Uri.parse('${APIConstants.authAPIUrl}/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final data = json['data'];

      return UserModel.fromJson(data);
    } else {
      throw Exception('Failed to load user');
    }
  }
}
