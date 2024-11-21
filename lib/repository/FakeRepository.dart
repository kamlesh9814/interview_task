import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:interview_task/model/FakeModel.dart';
import 'package:interview_task/util/app_constants.dart';

class FakeRepository {
  /// Fetches data from the API.
  Future<List<FakeModel>> fetchFakeData() async {
    try {
      final response = await http
          .get(Uri.parse('${AppConstants.baseUrl}${AppConstants.photoUri}'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => FakeModel.fromJson(item)).toList();
      } else {
        throw Exception(
            "Failed to load data, status code: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error fetching data: $error");
    }
  }
}
