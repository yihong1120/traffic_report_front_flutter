import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:mockito/mockito.dart';
import 'package:traffic_report_front_flutter/components/media_picker.dart';

// Create a mock class for ImagePicker
class MockImagePicker extends Mock implements ImagePicker {
  MockImagePicker._() : implements = null;


class MockCamera extends Mock implements CameraDescription { };

void main() {
  group('MediaPicker', () {
    late final MockImagePicker mockImagePicker;
    late final List<CameraDescription> mockCameras;

// Create a mock class for Camera
class MockCamera extends Mock implements CameraDescription {}

    setUp(() {
      mockImagePicker = MockImagePicker();
      mockCameras = [MockCamera()];
    });

    testWidgets(
        'pickMedia should show modal bottom sheet when camera is available',
        (WidgetTester tester) async {
      // Mock the availableCameras method to return a list of cameras
      when(availableCameras()).thenAnswer((_) async => mockCameras);

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: Builder(builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () {
            MediaPicker.pickMedia(context, enableCamera: true);
          },
          child: const Text('Pick Media'),
        );
      }))));

      // Tap the button to show the modal bottom sheet
      await tester.tap(find.text('Pick Media'));
      await tester.pumpAndSettle();

      // Verify that showModalBottomSheet is called and a bottom sheet is displayed
      expect(find.byType(BottomSheet), findsOneWidget);
    });

    // Scenario: Camera is not available and gallery is selected
    testWidgets(
        'pickMedia should pick from gallery when camera is not available',
        (WidgetTester tester) async {
      // Mock the availableCameras method to throw an exception
      when(availableCameras())
          .thenThrow(CameraException('No Camera', 'No cameras are available'));

      // Mock the ImagePicker pickMultiImage method
      when(mockImagePicker.pickMultiImage()).thenAnswer((_) async => []);

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: Builder(builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () {
            MediaPicker.pickMedia(context, enableCamera: false);
          },
          child: const Text('Pick Media'),
        );
      }))));

      // Tap the button to pick media from the gallery
      await tester.tap(find.text('Pick Media'));
      await tester.pumpAndSettle();

      // Verify that pickMultiImage is called
      verify(mockImagePicker.pickMultiImage()).called(1);
    });

    // Scenario: User cancels the camera or gallery picker
    testWidgets('pickMedia should return null when user cancels the picker',
        (WidgetTester tester) async {
      // Mock the ImagePicker pickMultiImage method to return an empty list of XFile
      when(mockImagePicker.pickMultiImage()).thenAnswer((_) async => <XFile>[]);

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: Builder(builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () async {
            final result =
                await MediaPicker.pickMedia(context, enableCamera: false);
            expect(result, isNull);
          },
          child: const Text('Pick Media'),
        );
      }))));

      // Tap the button to pick media from the gallery
      await tester.tap(find.text('Pick Media'));
      await tester.pumpAndSettle();
    });

    // Scenario: User selects a single image from the camera
    testWidgets('pickMedia should allow picking a single image from the camera',
        (WidgetTester tester) async {
      // Mock the ImagePicker pickImage method to return a single image file
      final XFile mockFile = XFile('path/to/image.png');
      when(mockImagePicker.pickImage(source: ImageSource.camera))
          .thenAnswer((_) async => mockFile);

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: Builder(builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () async {
            final result =
                await MediaPicker.pickMedia(context, enableCamera: true);
            expect(result, isNotNull);
            expect(result!.length, 1);
            expect(result.first.path, 'path/to/image.png');
          },
          child: const Text('Pick Media'),
        );
      }))));

      // Tap the button to pick an image from the camera
      await tester.tap(find.text('Pick Media'));
      await tester.pumpAndSettle();

      // Verify that pickImage is called with the correct source
      verify(mockImagePicker.pickImage(source: ImageSource.camera)).called(1);
    });

    // Scenario: User selects multiple images from the gallery
    testWidgets(
        'pickMedia should allow picking multiple images from the gallery',
        (WidgetTester tester) async {
      // Mock the ImagePicker pickMultiImage method to return multiple image files
      final List<XFile> mockFiles = [
        XFile('path/to/image1.png'),
        XFile('path/to/image2.png'),
      ];
      when(mockImagePicker.pickMultiImage()).thenAnswer((_) async => mockFiles);

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: Builder(builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () async {
            final result =
                await MediaPicker.pickMedia(context, enableCamera: false);
            expect(result, isNotNull);
            expect(result!.length, 2);
          },
          child: const Text('Pick Media'),
        );
      }))));

      // Tap the button to pick multiple images from the gallery
      await tester.tap(find.text('Pick Media'));
      await tester.pumpAndSettle();

      // Verify that pickMultiImage is called
      verify(mockImagePicker.pickMultiImage()).called(1);
    });

    // Scenario: User selects a video from the camera
    testWidgets('pickMedia should allow picking a video from the camera',
        (WidgetTester tester) async {
      // Mock the ImagePicker pickVideo method to return a video file
      final XFile mockVideoFile = XFile('path/to/video.mp4');
      when(mockImagePicker.pickVideo(source: ImageSource.camera))
          .thenAnswer((_) async => mockVideoFile);

      // Build our app and trigger a frame.
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(body: Builder(builder: (BuildContext context) {
        return ElevatedButton(
          onPressed: () async {
            final result =
                await MediaPicker.pickMedia(context, enableCamera: true);
            expect(result, isNotNull);
            expect(result!.length, 1);
            expect(result.first.path, 'path/to/video.mp4');
          },
          child: const Text('Pick Media'),
        );
      }))));

      // Tap the button to pick a video from the camera
      await tester.tap(find.text('Pick Media'));
      await tester.pumpAndSettle();

      // Verify that pickVideo is called with the correct source
      verify(mockImagePicker.pickVideo(source: ImageSource.camera)).called(1);
    });
  });
}
