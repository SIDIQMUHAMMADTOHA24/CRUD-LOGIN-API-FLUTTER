import 'dart:convert';
import 'package:crud_interview/models/employe_model.dart';
import 'package:crud_interview/utils/api_constants.dart';
import 'package:http/http.dart' as http;

class EmployeServis {
  final String _baseUrl =
      'https://6487a169beba62972790dc46.mockapi.io/personal';

  // Get Data
  Future<List<EmployeModel>> getData() async {
    try {
      final response = await http.get(Uri.parse(APIConstants.crudAPIURL));
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map<EmployeModel>((json) =>
                EmployeModel.fromJson(Map<String, dynamic>.from(json)))
            .toList();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Add Data
  Future<List<EmployeModel>> addData(String name, String jobs) async {
    try {
      final response = await http.post(
        Uri.parse(APIConstants.crudAPIURL),
        headers: {'Accept': 'application/json'},
        body: {'name': name, 'jobs': jobs},
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final EmployeModel newKaryawan = EmployeModel.fromJson(responseData);
        final List<EmployeModel> existingData = await getData();

        if (!existingData.any((karyawan) => karyawan.id == newKaryawan.id)) {
          existingData.add(newKaryawan);
        }

        return existingData;
      } else if (jsonDecode(response.body)['message'] != null) {
        return [];
      } else {
        throw Exception('Failed to add data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update Data
  Future<List<EmployeModel>> updateData({
    required int id,
    required String name,
    required String jobs,
  }) async {
    try {
      final jsonBody = jsonEncode({
        'name': name,
        'jobs': jobs,
      });

      final response = await http.put(
        Uri.parse('${APIConstants.crudAPIURL}/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final EmployeModel updatedKaryawan =
            EmployeModel.fromJson(responseData);
        final List<EmployeModel> existingData = await getData();

        final index = existingData.indexWhere((karyawan) => karyawan.id == id);
        if (index != -1) {
          existingData[index] = updatedKaryawan;
        }

        return existingData;
      } else if (jsonDecode(response.body)['message'] != null) {
        return [];
      } else {
        throw Exception('Failed to update data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete Data
  Future<List<EmployeModel>> deleteData(int id) async {
    try {
      final response = await http.delete(Uri.parse('${APIConstants.crudAPIURL}/$id'));

      if (response.statusCode == 200) {
        final List<EmployeModel> existingData = await getData();
        existingData.removeWhere((karyawan) => karyawan.id == id);

        return existingData;
      } else {
        throw Exception('Failed to delete data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
