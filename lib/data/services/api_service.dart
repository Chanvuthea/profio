import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl =
      'https://680b38fed5075a76d98a428f.mockapi.io/profile';

  Future<List<Map<String, dynamic>>> fetchProfiles() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> profiles = List<Map<String, dynamic>>.from(
        json.decode(response.body),
      );
      return profiles;
    } else {
      throw Exception('Failed to load profiles');
    }
  }
}
