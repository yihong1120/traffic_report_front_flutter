import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class MediaPicker {
  static Future<List<XFile>?> pickMedia(BuildContext context, {bool enableCamera = false}) async {
    final ImagePicker picker = ImagePicker();

    if (enableCamera) {
      try {
         // 嘗試獲取可用相機列表
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          // 如果有可用相機，顯示完整菜單
          return showModalBottomSheet<List<XFile>>(
            context: context,
            builder: (context) => _MediaPickerMenu(picker: picker),
          );
        }
      } catch (e) {
        // 如果捕獲到異常（例如，相機存取被拒絕）
        debugPrint('Camera access denied: $e');
        // 直接顯示從圖片庫選擇的選項
        return picker.pickMultiImage();
      }
    }
    // 沒有啟用相機或相機不可用，直接從圖片庫中選擇
    return picker.pickMultiImage();
  }
}

class _MediaPickerMenu extends StatelessWidget {
  final ImagePicker picker;

  const _MediaPickerMenu({required this.picker});

  @override
  Widget build(BuildContext context) {
    // Store the Navigator state before the async gap
    final NavigatorState navigator = Navigator.of(context);

    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Select Photos'),
          onTap: () async {
            final List<XFile> photos = await picker.pickMultiImage();
            navigator.pop(photos); // Use the stored Navigator state
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Select Videos'),
          onTap: () async {
            final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
            navigator.pop(video != null ? [video] : null);
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Take a Photo'),
          onTap: () async {
            final XFile? photo = await picker.pickImage(source: ImageSource.camera);
            navigator.pop(photo != null ? [photo] : null);
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Record a Video'),
          onTap: () async {
            final XFile? video = await picker.pickVideo(source: ImageSource.camera);
            navigator.pop(video != null ? [video] : null);
          },
        ),
      ],
    );
  }
}