import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:sample_app/models/data_model.dart';

class ApiService {
  final String baseUrl =
      'https://jsonplaceholder.typicode.com'; 

  Future<List<dynamic>> fetchData(String endpoint) async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

//   Future<List<DataModel>> createPost({required Map<String, dynamic> data}) async {
//   final response = await http.post(
//     Uri.parse('$baseUrl/posts'),

//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(data),
//   );

//   if (response.statusCode == 200) {
//     log(response.body);
//   } else {
//     log("failed");
//   }

//   final responseData = jsonDecode(response.body) ;

//   final postList = responseData.map((e) => DataModel.fromJson(e)).toList();
//   return postList;
// }
  Future<DataModel> createPost({required Map<String, dynamic> data}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    log("before:${response.statusCode}");
    log("before:${response.body}");
    if (response.statusCode == 201) {
      log(response.body);
      final responseData = jsonDecode(response.body);
      return DataModel.fromJson(responseData);
    } else {
      log(response.body);
      throw Exception('Failed to create post');
    }
  }
}
