import 'package:test/test.dart';
import 'package:traffic_report_front_flutter/utils/media_utils.dart'; // Replace with your actual import path

void main() {
  group('MediaUtils', () {
    // Test case for checking MP4 video file
    test('returns true for an MP4 video file', () {
      var filePath = 'example.mp4';
      expect(MediaUtils.isVideoFile(filePath), isTrue);
    });

    // Test case for checking MOV video file
    test('returns true for a MOV video file', () {
      var filePath = 'example.mov';
      expect(MediaUtils.isVideoFile(filePath), isTrue);
    });

    // Test case for checking case insensitivity
    test('is case insensitive', () {
      var filePath = 'EXAMPLE.MP4';
      expect(MediaUtils.isVideoFile(filePath), isTrue);
    });

    // Test case for non-video file
    test('returns false for a non-video file', () {
      var filePath = 'example.png';
      expect(MediaUtils.isVideoFile(filePath), isFalse);
    });

    // Test case for a file without an extension
    test('returns false for a file without an extension', () {
      var filePath = 'example';
      expect(MediaUtils.isVideoFile(filePath), isFalse);
    });

    // Test case for a file with a different video extension
    test('returns false for a file with a different video extension', () {
      var filePath = 'example.avi';
      expect(MediaUtils.isVideoFile(filePath), isFalse);
    });

    // Test case for a file with a dot but no extension
    test('returns false for a file with a dot but no extension', () {
      var filePath = 'example.';
      expect(MediaUtils.isVideoFile(filePath), isFalse);
    });

    // Test case for a file with a leading dot
    test('returns false for a file with a leading dot', () {
      var filePath = '.example.mp4';
      expect(MediaUtils.isVideoFile(filePath), isFalse);
    });

    // Test case for an empty string
    test('returns false for an empty string', () {
      var filePath = '';
      expect(MediaUtils.isVideoFile(filePath), isFalse);
    });
  });
}
