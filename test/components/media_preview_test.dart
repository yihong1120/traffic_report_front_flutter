import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/components/media_preview.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  group('MediaPreview', () {
    test('_buildVideoPlayer returns VideoPlayer with correct controller', () {
      final controller = VideoPlayerController.network('http://example.com/video.mp4');

      final result = _buildVideoPlayer(controller);

      expect(result, isA<VideoPlayer>());
      expect(result.controller, equals(controller));
    });

    test('_buildRemoveVideoButton returns IconButton with correct icon and onPressed', () {
      final controller = VideoPlayerController.network('http://example.com/video.mp4');
      final file = XFile('/path/to/file');

      final result = _buildRemoveVideoButton(controller, file);

      expect(result, isA<IconButton>());
      expect(result.icon, equals(const Icon(Icons.remove_circle)));
      expect(result.onPressed, isNotNull);
    });
  });
}
