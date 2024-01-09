import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';

class MediaPicker {
Future<List<XFile>?> pickMedia(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    bool enableCamera = true;
    if (enableCamera) {
      try {
        // 嘗試獲取可用相機列表
        final cameras = await availableCameras();
        if (cameras.isNotEmpty) {
          // 如果有可用相機，顯示完整菜單
          showModalBottomSheet<List<XFile>?>(
            builder: (_) => _MediaPickerMenu(picker: picker),
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
  Widget build(BuildContext _) {
    return Wrap(
      children: <Widget>[
        ListTile(
          leading: const Icon(Icons.photo_library),
          title: const Text('Select Photos'),
          onTap: () async {
            final List<XFile> photos = await picker.pickMultiImage();
            Navigator.pop(context, photos); // 確保返回 List<XFile>
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Select Videos'),
          onTap: () async {
            final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
            Navigator.pop(context, video != null ? [video] : null); // 將單個 XFile 包裝為 List
          },
        ),
        ListTile(
          leading: const Icon(Icons.camera_alt),
          title: const Text('Take a Photo'),
        onTap: () async {
            final XFile? photo = await picker.pickImage(source: ImageSource.camera);
            Navigator.pop(_, photo != null ? [photo] : null); // 同上
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Record a Video'),
          onTap: () {
            final XFile? video = await picker.pickVideo(source: ImageSource.camera);
            Navigator.pop(context, video != null ? [video] : null); // 同上
          },
        ),
      ],
    );
  }
          onTap: () {
            final XFile? photo = await picker.pickImage(source: ImageSource.camera);
            Navigator.pop(_, photo != null ? [photo] : null); // 同上
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Record a Video'),
          onTap: () async {
            final XFile? video = await picker.pickVideo(source: ImageSource.camera);
            Navigator.pop(_, video != null ? [video] : null); // 同上
          },
        ),
      ],
    );
  }
}
          onTap: () {
            final XFile? photo = await picker.pickImage(source: ImageSource.camera);
            Navigator.pop(_, photo != null ? [photo] : null); // 同上
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Record a Video'),
          onTap: () async {
            final XFile? video = await picker.pickVideo(source: ImageSource.camera);
            Navigator.pop(_, video != null ? [video] : null); // 同上
          },
        ),
      ],
    );
  }
}
          onTap: () async {
            final XFile? photo = await picker.pickImage(source: ImageSource.camera);
            Navigator.pop(_, photo != null ? [photo] : null); // 同上
          },
        ),
        ListTile(
          leading: const Icon(Icons.videocam),
          title: const Text('Record a Video'),
          onTap: () async {
            final XFile? video = await picker.pickVideo(source: ImageSource.camera);
            Navigator.pop(_, video != null ? [video] : null); // 同上
          },
        ),
      ],
    );
  }
}
}