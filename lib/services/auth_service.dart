import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/accounts';

  // Allow for the storage to be set for testing purposes
  static FlutterSecureStorage storage = FlutterSecureStorage();

  // Allow for the client to be set for testing purposes
  static http.Client client = http.Client();

  static Future<bool> login(String username, String password) async {
    var url = Uri.parse('$_baseUrl/api/login/');
    var response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'}, // 指定发送的数据类型为 JSON
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      String? authToken = data['token']; // 从响应中获取 token
      await storage.write(key: 'auth_token', value: authToken);
      return true;
    } else {
      // 登录失败
      return false;
    }
  }

  static Future<bool> logout() async {
    var url = Uri.parse('$_baseUrl/accounts/api/logout/');
    var token = await _getToken();
    var response = await client.post(url, headers: {
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 204) {
      await storage.delete(key: 'auth_token'); // 删除存储的 token
      return true;
    } else {
      // 注销失败
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
    var url = Uri.parse('$_baseUrl/api/password/change/');
    var token = await _getToken();
    var response = await client.post(url, body: {
      'old_password': oldPassword,
      'new_password': newPassword,
    }, headers: {
      'Authorization': 'Token $token',
    });

    if (response.statusCode == 200) {
      // 密码更改成功
      return true;
    } else {
      // 密码更改失败
      return false;
    }
  }

  static Future<bool> changeEmail(String newEmail) async {
    var url = Uri.parse('$_baseUrl/api/email/change/');
    var token = await _getToken();
    var response = await client.post(url, body: {
      'email': newEmail,
    }, headers: {
      'Authorization': 'Token $token',
    });

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
      final token = await storage.read(key: 'auth_token');
      return token;
    } catch (e) {
      // 处理任何异常，例如无法访问存储
      return null;
    }
  }
}
