import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/models/social_account.dart';

void main() {
  group('SocialAccount', () {
    // 測試從 JSON 正確創建 SocialAccount 對象
    test('fromJson returns a valid instance of SocialAccount', () {
      Map<String, dynamic> json = {'provider': 'facebook', 'uid': '12345'};
      SocialAccount account = SocialAccount.fromJson(json);

      expect(account.provider, 'facebook');
      expect(account.uid, '12345');
    });

    // 測試將 SocialAccount 對象正確轉換為 JSON
    test('toJson returns a JSON map containing the proper data', () {
      SocialAccount account = SocialAccount(provider: 'google', uid: '67890');
      Map<String, dynamic> json = account.toJson();

      expect(json['provider'], 'google');
      expect(json['uid'], '67890');
    });

    // 處理邊界情況，例如空值或不正確的類型
    test('fromJson throws TypeError when JSON is incomplete', () {
      Map<String, dynamic> json = {'uid': '12345'};
      expect(() => SocialAccount.fromJson(json), throwsA(isA<TypeError>()));
    });

    test('fromJson throws TypeError when JSON has wrong types', () {
      Map<String, dynamic> json = {'provider': 123, 'uid': '12345'};
      expect(() => SocialAccount.fromJson(json), throwsA(isA<TypeError>()));
    });
  });
}
