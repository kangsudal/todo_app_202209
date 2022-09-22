//all the api call will be here
import 'dart:convert';

import 'package:http/http.dart' as http;

class TodoService {
  //DELETE
  static Future<bool> deleteById(String id) async {
    //delete the item
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    return response.statusCode == 200;
  }

  //GET(READ)
  static Future<List?> fetchTodo() async {
    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      return result;
    } else {
      return null;
    }
  }

  //PUT(UPDATE)
  static Future<bool> updateTodo(String id, Map body) async {
    var url = Uri.https('api.nstack.in', 'v1/todos/$id');
    var response = await http.put(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  //POST(CREATE)
  static Future<bool> addTodo(Map body) async {
    var url = Uri.https('api.nstack.in', 'v1/todos');
    var response = await http.post(
      url,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 201;
  }
}
