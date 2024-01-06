
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class MediaPicker {
  static Future<List<XFile>?> pickMedia(BuildContext context, {bool enableCamera = false}) async {
    final ImagePicker picker = ImagePicker();

    if (enableCamera) {
      // 检查摄像头是否可用
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        // 显示选择媒体或使用摄像头的菜单
        return showModalBottomSheet<List<XFile>>(
          context: context,
          builder: (context) => _MediaPickerMenu(picker: picker),
        );
      }
    }
    // 没有可用摄像头，直接选择媒体
    return picker.pickMultiImage();
  }
}

class _MediaPickerMenu extends StatelessWidget {
  final ImagePicker picker;

  const _MediaPickerMenu({required this.picker});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Select Photos'),
          onTap: () async {
            Navigator.pop(context, await picker.pickMultiImage());
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Select Videos'),
          onTap: () async {
            Navigator.pop(context, await picker.pickVideo(source: ImageSource.gallery));
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Take a Photo'),
          onTap: () async {
            Navigator.pop(context, [await picker.pickImage(source: ImageSource.camera)]);
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Record a Video'),
          onTap: () async {
            Navigator.pop(context, [await picker.pickVideo(source: ImageSource.camera)]);
          },
        ),
      ],
    );
  }
}