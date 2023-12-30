import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/social_account.dart';

class SocialService {
  static Future<List<SocialAccount>> getConnectedAccounts() async {
    // 这里的 URL 应该指向您的后端 API
    var url = Uri.parse('${dotenv.env['API_URL']}/connected-accounts');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> accountsJson = json.decode(response.body);
      List<SocialAccount> accounts = accountsJson
          .map((accountJson) => SocialAccount.fromJson(accountJson))
          .toList();
      return accounts;
    } else {
      throw Exception('Failed to load connected accounts');
    }
  }

  static Future<List<SocialProvider>> getAvailableProviders() async {
    // 这里的 URL 应该指向您的后端 API
    var url = Uri.parse('${dotenv.env['API_URL']}/available-providers');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> providersJson = json.decode(response.body);
      List<SocialProvider> providers = providersJson
          .map((providerJson) => SocialProvider.fromJson(providerJson))
          .toList();
      return providers;
    } else {
      throw Exception('Failed to load available providers');
    }
  }

  static Future<bool> disconnectAccount(SocialAccount account) async {
    // 这里的 URL 应该指向您的后端 API
    var url = Uri.parse('${dotenv.env['API_URL']}/disconnect-account');
    var response = await http.post(url, body: account.toJson());

    return response.statusCode == 200;
  }

  static Future<void> connectWithProvider(SocialProvider provider) async {
    // 构建 OAuth 登录 URL
    final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000';
    final String loginUrl = '$baseUrl/social/login/${provider.id}';

    // 使用 url_launcher 打开浏览器窗口
    if (await canLaunchUrl(loginUrl)) {
      await launch(loginUrl);
    } else {
      throw 'Could not launch $loginUrl';
    }
  }
}

// 假设 SocialProvider 是一个包含提供者信息的模型
class SocialProvider {
  final String id;
  final String name;

  SocialProvider({required this.id, required this.name});

  factory SocialProvider.fromJson(Map<String, dynamic> json) {
    return SocialProvider(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}