import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/models/media_file.dart';

void main() {
  group('MediaFile', () {
    // 測試數據
    const String testId = '123';
    const String testUrl = 'https://example.com/media/123';
    final Map<String, dynamic> testJson = {
      'id': testId,
      'url': testUrl,
    };

    test('fromJson should return a valid MediaFile instance', () {
      // 使用測試數據從JSON創建MediaFile實例
      final MediaFile result = MediaFile.fromJson(testJson);

      // 驗證fromJson是否正確創建了MediaFile實例
      expect(result, isA<MediaFile>());
      expect(result.id, testId);
      expect(result.url, testUrl);
    });

    test('toJson should return a JSON map containing the proper data', () {
      // 創建一個MediaFile實例
      final MediaFile mediaFile = MediaFile(id: testId, url: testUrl);

      // 將MediaFile實例轉換為JSON
      final Map<String, dynamic> json = mediaFile.toJson();

      // 驗證toJson是否正確轉換了數據
      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], testId);
      expect(json['url'], testUrl);
    });

    test('fromJson should throw FormatException when id is missing', () {
      expect(() => MediaFile.fromJson({'url': 'https://example.com/media/123'}),
          throwsFormatException);
    });

    test('fromJson should throw FormatException when url is missing', () {
      expect(() => MediaFile.fromJson({'id': '123'}), throwsFormatException);
    });

    test('fromJson should handle null id gracefully', () {
      final result = MediaFile.fromJson(
          {'id': null, 'url': 'https://example.com/media/123'});
      expect(result.id, isNull);
      expect(result.url, 'https://example.com/media/123');
    });

    test('fromJson should handle null url gracefully', () {
      final result = MediaFile.fromJson({'id': '123', 'url': null});
      expect(result.id, '123');
      expect(result.url, isNull);
    });
  });
}
