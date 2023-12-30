/// Tests for the 'launchUrl' function in the 'SocialService' class.
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:traffic_report_front_flutter/services/social_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MockUrlLauncher extends Mock implements UrlLauncher {}

/// The 'main' function is the entry point for the tests and contains a group of tests for the 'launchUrl' function.
void main() {
  group('launchUrl', () {
    final mockUrlLauncher = MockUrlLauncher();
    final socialService = SocialService();

    /// Tests if the 'launchUrl' function can successfully launch a URL.
    test('launches URL successfully', () async {
      when(mockUrlLauncher.canLaunch(any)).thenAnswer((_) async => true);
      when(mockUrlLauncher.launch(any)).thenAnswer((_) async => true);

      expect(await socialService.launchUrl('http://valid.url'), completes);
    });

    /// Tests if the 'launchUrl' function throws an exception when the URL cannot be launched.
    test('throws an exception when URL cannot be launched', () async {
      when(mockUrlLauncher.canLaunch(any)).thenAnswer((_) async => false);

      expect(() async => await socialService.launchUrl('http://invalid.url'), throwsA(isA<Exception>()));
    });
  });
}
