import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/accounts';

  // Allow for the storage to be set for testing purposes
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  // Allow for the client to be set for testing purposes
  static http.Client client = http.Client();

  // Google 登录的客户端 ID
  static const String _googleClientId = 'YOUR_CLIENT_ID.apps.googleusercontent.com';

  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: _googleClientId,
  );

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Google 登录
  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);

        final User? user = authResult.user;
        return user; // 返回登录用户的信息
      }
    } catch (e) {
      // 如果登录失败，则打印错误信息
      print("Error signing in with Google: $e");
    }
    return null; // 如果登录失败或者用户取消登录，则返回 null
  }

  // Facebook 登录
  static Future<User?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      if (loginResult.status == LoginStatus.success) {
        final AccessToken accessToken = loginResult.accessToken!;

        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);

        final User? user = authResult.user;
        return user;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

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

  // 這個公共方法允許其他服務獲取 access token
  static Future<String?> getAccessToken() async {
    return await _getToken();
  }

  // 這是一個私有方法，用於從安全存儲讀取 access token
  static Future<String?> _getToken() async {
    try {
      return await storage.read(key: 'access_token');
    } catch (e) {
      // 這裡你可以添加錯誤處理邏輯，如日誌記錄
      print('Error reading access token: $e');
      return null;
    }
  }

  // 刷新令牌的方法
  static Future<bool> refreshToken() async {
    var refreshToken = await storage.read(key: 'refresh_token');
    if (refreshToken == null) {
      print('No refresh token available.');
      return false;
    }

    var url = Uri.parse('$_baseUrl/api/token/refresh/'); // 根据你的API路径进行调整
    var response = await client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'refresh': refreshToken}),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      await storage.write(key: 'access_token', value: data['access']);
      return true;
    } else {
      // 如果刷新失败，可能需要执行注销或其他操作
      print('Failed to refresh token: ${response.statusCode}');
      return false;
    }
  }

  // 一个辅助方法，用于在发出请求之前检查和刷新令牌
  static Future<String?> getValidAccessToken() async {
    var accessToken = await _getToken();
    if (accessToken == null || _isTokenExpired(accessToken)) {
      // 如果令牌为空或已过期，尝试刷新
      bool refreshed = await refreshToken();
      if (refreshed) {
        accessToken = await _getToken(); // 重新获取新的访问令牌
      } else {
        return null; // 刷新失败，返回 null
      }
    }
    return accessToken;
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

  // 检查 JWT 令牌是否过期
  static bool _isTokenExpired(String token) {
    try {
      // 解码 token，但不验证签名
      final jwt = JWT.decode(token);

      // 获取 token 的过期时间
      final DateTime? expiryDate = jwt.payload['exp'] != null
        ? DateTime.fromMillisecondsSinceEpoch(jwt.payload['exp'] * 1000)
        : null;

      // 检查 token 是否已过期
      if (expiryDate != null) {
        return expiryDate.isBefore(DateTime.now());
      } else {
        // 如果 token 没有 exp 字段，假定它没有过期
        return false;
      }
    } catch (e) {
      // 如果解码失败或其他错误发生
      print('Error decoding token: $e');
      return true; // 如果有错误，默认认为 token 已过期
    }
  }
}
