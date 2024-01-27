import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/social_account.dart';

class SocialService {
  final http.Client httpClient;
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:8000/accounts';

  SocialService({http.Client? client}) : httpClient = client ?? http.Client();

  Future<List<SocialAccount>> getConnectedAccounts() async {
    var url = Uri.parse('$_baseUrl/api/social-connections');
    var response = await httpClient.get(url);

    if (response.statusCode == 200) {
      try {
        List<dynamic> accountsJson = json.decode(response.body);
        List<SocialAccount> accounts = accountsJson
            .map((accountJson) => SocialAccount.fromJson(accountJson))
            .toList();
        return accounts;
      } catch (e) {
        print('Error parsing JSON: $e');
        print('Response body: ${response.body}');
        throw Exception('Failed to parse connected accounts JSON');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
      print('Response body: ${response.body}');
      throw Exception('Failed to load connected accounts, status code: ${response.statusCode}');
    }
  }

  Future<List<SocialProvider>> getAvailableProviders() async {
    var url = Uri.parse('$_baseUrl/api/available-providers');
    var response = await httpClient.get(url);

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

  Future<bool> disconnectAccount(SocialAccount account) async {
    var url = Uri.parse('$_baseUrl/api/disconnect-account');
    var response = await httpClient.post(url, body: account.toJson());

    return response.statusCode == 200;
  }

  Future<void> connectWithProvider(SocialProvider provider) async {
    final Uri loginUri = Uri.parse('$_baseUrl/api/social/login/${provider.id}');

    if (await canLaunchUrl(loginUri)) {
      await launchUrl(loginUri);
    } else {
      throw 'Could not launch $loginUri';
    }
  }
}

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
