import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/accounts';

  // Allow for the storage to be set for testing purposes
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  // Allow for the client to be set for testing purposes
  static http.Client client = http.Client();

  static Future<bool> login(String username, String password) async {
    var url = Uri.parse('$_baseUrl/api/login/');
    var response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      await storage.write(key: 'refresh_token', value: data['refresh']);
      await storage.write(key: 'access_token', value: data['access']);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> logout() async {
    var url = Uri.parse('$_baseUrl/api/logout/');
    var accessToken = await storage.read(key: 'access_token');
    var refreshToken = await storage.read(key: 'refresh_token');
    
    var response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'refresh': refreshToken,
      }),
    );

    if (response.statusCode == 204) {
      await storage.delete(key: 'access_token');
      await storage.delete(key: 'refresh_token');
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> register(String username, String email, String password1, String password2) async {
    var url = Uri.parse('$_baseUrl/register/');
    var response = await client.post(url, body: {
      'username': username,
      'email': email,
      'password1': password1,
      'password2': password2,
    });

    if (response.statusCode == 200) {
      // 注册成功
      return true;
    } else {
      // 注册失败
      return false;
    }
  }

  static Future<bool> verify(String code) async {
    var url = Uri.parse('$_baseUrl/api/verify/'); // 确保这是正确的验证 API 端点
    var response = await client.post(url, body: {
      'code': code,
    });

    return response.statusCode == 200;
  }

  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    var url = Uri.parse('$_baseUrl/api/password-change/');
    var accessToken = await _getToken();
    var response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'old_password': oldPassword,
        'new_password': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      // 密码更改成功
      return true;
    } else {
      // 密码更改失败
      return false;
    }
  }

  static Future<bool> changeEmail(String newEmail) async {
    var url = Uri.parse('$_baseUrl/api/email-change/');
    var accessToken = await _getToken();
    var response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: json.encode({
        'email': newEmail,
      }),
    );

    if (response.statusCode == 200) {
      // 邮箱更改成功
      return true;
    } else {
      // 邮箱更改失败
      return false;
    }
  }

  static Future<bool> deleteAccount() async {
    var url = Uri.parse('$_baseUrl/api/delete-account/');
    var token = await _getToken();
    var response = await client.delete(url, headers: {
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      // 账户删除成功
      await storage.delete(key: 'auth_token'); // 删除存储的 token
      return true;
    } else {
      // 账户删除失败
      return false;
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await _getToken(); // 获取存储的令牌
    return token != null && token.isNotEmpty;
  }

  static Future<String?> _getToken() async {
    try {
      return await storage.read(key: 'access_token');
    } catch (e) {
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getUserInfo() async {
    var url = Uri.parse('$_baseUrl/api/get-user-info/'); // 修改为正确的API路径
    
    var accessToken = await _getToken();
    var response = await client.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      // 打印错误日志或进行其他错误处理
      print('Failed to fetch user info: ${response.body}');
      return null;
    }
  }
}
