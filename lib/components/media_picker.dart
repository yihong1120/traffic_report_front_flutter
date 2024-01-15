import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class MediaPicker {
  static Future<List<XFile>?> pickMedia(BuildContext context, NavigatorState navigator,
      {bool enableCamera = false}) async {
    final ImagePicker picker = ImagePicker();

    if (enableCamera) {
      try {
        // Attempt to get the list of available cameras
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          // If there are available cameras, show the full menu
          return showModalBottomSheet<List<XFile>>(
            context: context,
            builder: (BuildContext context) => _MediaPickerMenu(picker: picker),
          );
        }
      } catch (e) {
        // If an exception is caught (e.g., camera access denied)
        debugPrint('Camera access denied: $e');
        // Directly show the option to select from the gallery
        return picker.pickMultiImage();
      }
    }
    // If the camera is not enabled or not available, directly select from the gallery
    return picker.pickMultiImage();
  }
}

class _MediaPickerMenu extends StatelessWidget {
  final ImagePicker picker;

  const _MediaPickerMenu({required this.picker});

  @override
  Widget build(BuildContext context) {
    // Capture the values that depend on the context before the async gap
    final NavigatorState navigator = Navigator.of(context);

    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Select Photos'),
          onTap: () => _handleImageSelection(
              context, navigator, picker, ImageSource.gallery, false),
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Select Videos'),
          onTap: () => _handleImageSelection(
              context, navigator, picker, ImageSource.gallery, true),
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Take a Photo'),
          onTap: () => _handleImageSelection(
              context, navigator, picker, ImageSource.camera, false),
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Record a Video'),
          onTap: () => _handleImageSelection(
              context, navigator, picker, ImageSource.camera, true),
        ),
      ],
    );
  }

  void _handleImageSelection(BuildContext context, NavigatorState navigator,
      ImagePicker picker, ImageSource source, bool isVideo) async {
    try {
      List<XFile>? files;
      if (isVideo) {
        final XFile? video = await picker.pickVideo(source: source);
        if (video != null) {
          files = [video];
        }
      } else {
        if (source == ImageSource.camera) {
          final XFile? photo = await picker.pickImage(source: source);
          if (photo != null) {
            files = [photo];
          }
        } else {
          files = await picker.pickMultiImage();
        }
      }
      navigator.pop(files);
    } catch (e) {
      debugPrint('Error picking media: $e');
      navigator.pop();
    }
  }
}
