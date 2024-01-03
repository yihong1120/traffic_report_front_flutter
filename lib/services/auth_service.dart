
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  static final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000';

  static Future<bool> login(String username, String password) async {
    var url = Uri.parse('$_baseUrl/login/');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      // 这里应该处理登录成功后的逻辑，例如保存 token
      return true;
    } else {
      // 登录失败
      return false;
    }
  }

  static Future<bool> register(String username, String email, String password1, String password2) async {
    var url = Uri.parse('$_baseUrl/register/');
    var response = await http.post(url, body: {
      'username': username,
      'email': email,
      'password1': password1,
      'password2': password2,
    });

    if (response.statusCode == 201) {
      // 注册成功
      return true;
    } else {
      // 注册失败
      return false;
    }
  }

  static Future<bool> verify(String code) async {
    var url = Uri.parse('$_baseUrl/verify/'); // 替换为正确的验证 API 端点
    var response = await http.post(url, body: {
      'code': code,
    });

    return response.statusCode == 200;
  }

  static Future<bool> verifyEmail(String code) async {
    var url = Uri.parse('$_baseUrl/verify-email/');
    var response = await http.post(url, body: {
      'code': code,
    });

    if (response.statusCode == 200) {
      // 验证成功
      return true;
    } else {
      // 验证失败
      return false;
    }
  }

  static Future<bool> changePassword(String oldPassword, String newPassword) async {
    var url = Uri.parse('$_baseUrl/change-password/');
    var response = await http.post(url, body: {
      'old_password': oldPassword,
      'new_password': newPassword,
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
    var url = Uri.parse('$_baseUrl/change-email/');
    var response = await http.post(url, body: {
      'email': newEmail,
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
    var url = Uri.parse('$_baseUrl/delete-account/');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      // 账户删除成功
      return true;
    } else {
      // 账户删除失败
      return false;
    }
  }

  // 示例：检查用户是否已登录
  static Future<bool> isLoggedIn() async {
    // 这里的逻辑取决于您如何处理认证
    // 例如，检查是否有有效的认证令牌

    final token = await _getToken(); // 获取存储的令牌
    return token != null && token.isNotEmpty;
  }

  // 示例：获取存储的令牌
  static Future<String?> _getToken() async {
    // 这里应该包含从存储中获取令牌的逻辑
    // 例如，使用 SharedPreferences

    // 返回 null 表示没有令牌或令牌无效
    return null;
  }
}