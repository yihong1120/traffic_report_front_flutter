import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:traffic_report_front_flutter/services/social_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MockUrlLauncher extends Mock implements UrlLauncher {}

void main() {
  group('launchUrl', () {
    final mockUrlLauncher = MockUrlLauncher();
    final socialService = SocialService();

    test('launches URL successfully', () async {
      when(mockUrlLauncher.canLaunch(any)).thenAnswer((_) async => true);
      when(mockUrlLauncher.launch(any)).thenAnswer((_) async => true);

      expect(await socialService.launchUrl('http://valid.url'), completes);
    });

    test('throws an exception when URL cannot be launched', () async {
      when(mockUrlLauncher.canLaunch(any)).thenAnswer((_) async => false);

      expect(() async => await socialService.launchUrl('http://invalid.url'), throwsA(isA<Exception>()));
    });
  });
}
