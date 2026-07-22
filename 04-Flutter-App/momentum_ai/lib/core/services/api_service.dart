import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // 👇 Physical phone + adb reverse ke liye 'localhost' use karein
  static const String baseUrl = 'http://192.168.20.34:5000';

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
  }) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: body != null ? jsonEncode(body) : null,
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> delete(String endpoint) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Request failed');
    }
  }

  // ---------- AUTH ----------
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': fullName,
        'email': email,
        'password': password,
      }),
    );
    return _handleResponse(response);
  }

  // ---------- DASHBOARD ----------
  static Future<Map<String, dynamic>> getDashboardData() async {
    return get('/api/dashboard');
  }

  // ---------- TASKS ----------
  static Future<List<dynamic>> getTasks() async {
    final res = await get('/api/tasks');
    return res['tasks'] as List<dynamic>;
  }

  static Future<Map<String, dynamic>> createTask(
    Map<String, dynamic> taskData,
  ) async {
    return post('/api/tasks', body: taskData);
  }

  static Future<Map<String, dynamic>> toggleTask(String taskId) async {
    return put('/api/tasks/$taskId/toggle');
  }

  static Future<Map<String, dynamic>> getHabits() async {
    return get('/api/habits');
  }

  static Future<Map<String, dynamic>> toggleHabit(String habitId) async {
    return put('/api/habits/$habitId/toggle');
  }

  // ---------- STATS ----------
  static Future<Map<String, dynamic>> getStats() async {
    return get('/api/stats');
  }

  // ---------- CALENDAR ----------
  static Future<List<dynamic>> getEvents() async {
    final res = await get('/api/calendar/events');
    return res['events'] as List<dynamic>;
  }

  // ---------- PROFILE ----------
  static Future<Map<String, dynamic>> getProfile() async {
    return get('/api/profile');
  }
}
