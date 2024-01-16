import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/mockito.dart';
import 'package:traffic_report_front_flutter/components/media_preview.dart';
import 'package:traffic_report_front_flutter/utils/media_utils.dart';
import 'package:video_player/video_player.dart';

// Create a mock class for VideoPlayerController
class MockVideoPlayerController extends Mock implements VideoPlayerController {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('MediaPreview', () {
    late List<XFile> mediaFiles;
    late Function(XFile file) onRemove;

    setUp(() {
      // Initialize media files and onRemove callback
      mediaFiles = [
        XFile('path/to/image.jpg'),
        XFile('path/to/video.mp4'),
      ];
      onRemove = (XFile file) {
        mediaFiles.remove(file);
      };
    });

    testWidgets('displays image and video previews',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MediaPreview(
            mediaFiles: mediaFiles,
            onRemove: onRemove,
          ),
        ),
      ));

      // Verify image preview is displayed
      expect(find.byType(Image), findsOneWidget);

      // Verify video preview is displayed
      expect(find.byType(VideoPlayer), findsOneWidget);
    });

    testWidgets('removes media on tap of remove button',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MediaPreview(
            mediaFiles: mediaFiles,
            onRemove: onRemove,
          ),
        ),
      ));

      // Tap the remove button for the image
      await tester.tap(find.byIcon(Icons.remove_circle).first);
      await tester.pumpAndSettle();

      // Verify the image is removed
      expect(find.byType(Image), findsNothing);

      // Tap the remove button for the video
      await tester.tap(find.byIcon(Icons.remove_circle).last);
      await tester.pumpAndSettle();

      // Verify the video is removed
      expect(find.byType(VideoPlayer), findsNothing);
    });

    // Test to verify that the image is displayed with the correct data
    testWidgets('displays image with correct data',
        (WidgetTester tester) async {
      // Create a fake image data
      final Uint8List fakeImageData =
          Uint8List.fromList(List.generate(100, (index) => index));

      // Mock the XFile to return the fake image data
      final XFile imageFile =
          mediaFiles.firstWhere((file) => !MediaUtils.isVideoFile(file.path));
      when(imageFile.readAsBytes()).thenAnswer((_) async => fakeImageData);

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MediaPreview(
            mediaFiles: mediaFiles,
            onRemove: onRemove,
          ),
        ),
      ));

      // Pump to complete the FutureBuilder
      await tester.pump();

      // Verify that the image is displayed with the correct data
      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final Image imageWidget = tester.widget(imageFinder) as Image;
      final MemoryImage memoryImage = imageWidget.image as MemoryImage;
      expect(memoryImage.bytes, fakeImageData);
    });

    // Test to verify the loading state for the image preview
    testWidgets('displays loading indicator while image is loading',
        (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MediaPreview(
            mediaFiles: mediaFiles,
            onRemove: onRemove,
          ),
        ),
      ));

      // Verify that a CircularProgressIndicator is displayed while the image is loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Additional tests can be added here to verify other aspects of the MediaPreview
  });
}
